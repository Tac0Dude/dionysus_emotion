import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/history/history_seen_service.dart';
import '../../data/providers.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/entry.dart';
import '../../domain/entities/quadrant.dart';
import '../common/date_helpers.dart';
import '../entry/emotion_articles.dart';
import '../entry/quadrant_visuals.dart';
import '../shell/bottom_nav.dart';
import '../theme/app_colors.dart';
import 'day_detail_screen.dart';
import 'entry_detail_screen.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/jar.dart';
import 'widgets/period_toggle.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with WidgetsBindingObserver {
  HistoryPeriod _period = HistoryPeriod.week;
  bool _loading = true;
  List<Entry> _entries = const [];
  Map<int, Emotion> _emotions = const {};
  Map<int, Quadrant> _quadrants = const {};
  Map<int, String> _quadrantLabelByEmotion = const {};

  StreamSubscription<List<Entry>>? _entriesSub;
  int? _parentId;

  late final HistorySeenService _seenService;

  // Seuil figé pour cette consultation : les saisies postérieures scintillent
  // comme nouveaux ajouts. Capturé à l'ouverture, avant d'enregistrer la visite.
  DateTime? _newSince;

  @override
  void initState() {
    super.initState();
    _seenService = ref.read(historySeenServiceProvider);
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    // Fin de consultation : tout ce qui est affiché est désormais « vu ».
    _seenService.markSeen();
    _entriesSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Les saisies faites depuis le widget passent par une autre connexion SQLite
    // et ne notifient pas le cache de streams Drift de l'app. Au retour au
    // premier plan, on force une relecture pour récupérer ces saisies.
    if (state == AppLifecycleState.resumed && _parentId != null) {
      ref.read(entryRepositoryProvider).refreshEntryStreams();
    } else if (state == AppLifecycleState.paused) {
      // L'app passe en arrière-plan alors qu'on regarde l'historique : on fige
      // la consultation pour ne pas re-signaler ces saisies au prochain retour.
      _seenService.markSeen();
    }
  }

  Future<void> _load() async {
    final parent =
        await ref.read(parentRepositoryProvider).getCurrentParent();
    if (parent == null) {
      if (!mounted) return;
      setState(() => _loading = false);
      return;
    }
    final refRepo = ref.read(referenceRepositoryProvider);
    final emotionsList = await refRepo.getAllEmotions();
    final quadrants = await refRepo.getQuadrants();

    _newSince = await _seenService.lastSeenAt();
    _parentId = parent.id;
    _emotions = {for (final e in emotionsList) e.id: e};
    _quadrants = {for (final q in quadrants) q.id: q};
    _quadrantLabelByEmotion = {
      for (final e in emotionsList)
        e.id: _quadrants[e.quadrantId]?.label ?? ''
    };
    _subscribeEntries();
  }

  void _subscribeEntries() {
    final parentId = _parentId;
    if (parentId == null) return;
    final repo = ref.read(entryRepositoryProvider);
    _entriesSub?.cancel();
    _entriesSub = repo.watchAllForParent(parentId).listen((entries) {
      if (!mounted) return;
      setState(() {
        _entries = entries;
        _loading = false;
      });
    });
    // Capte d'emblée d'éventuelles saisies faites via le widget (le stream Drift
    // de l'app n'est pas notifié des écritures faites par une autre connexion).
    repo.refreshEntryStreams();
  }

  List<Entry> _entriesInPeriod() {
    final range = periodRange(_period);
    return _entries
        .where((e) =>
            !e.createdAt.isBefore(range.start) &&
            e.createdAt.isBefore(range.end))
        .toList();
  }

  Map<int, int> _emotionCounts(List<Entry> entries) {
    final result = <int, int>{};
    for (final e in entries) {
      result[e.emotionId] = (result[e.emotionId] ?? 0) + 1;
    }
    return result;
  }

  List<EmotionBubbleData> _bubblesFor(List<Entry> entries) {
    return entries
        .map((entry) {
          final emotion = _emotions[entry.emotionId];
          if (emotion == null) return null;
          final quadrantLabel = _quadrantLabelByEmotion[emotion.id] ?? '';
          final visual = visualFor(quadrantLabel);
          final isNew =
              _newSince != null && entry.createdAt.isAfter(_newSince!);
          return EmotionBubbleData(
            id: entry.id,
            emotionName: emotion.name,
            shape: visual.shape,
            color: visual.color,
            intensity: entry.intensity,
            createdAt: entry.createdAt,
            isNew: isNew,
          );
        })
        .whereType<EmotionBubbleData>()
        .toList();
  }

  void _openEntry(int entryId) {
    final entry = _entries.firstWhere(
      (e) => e.id == entryId,
      orElse: () => throw StateError('Entry $entryId not found'),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EntryDetailScreen(entry: entry),
      ),
    );
  }

  Map<DateTime, Color> _dayColorsForMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1);
    // Chaque jour prend la couleur de sa dernière saisie (createdAt le plus
    // récent), pas du quadrant majoritaire.
    final latestByDay = <DateTime, Entry>{};
    for (final e in _entries) {
      if (e.createdAt.isBefore(start) || !e.createdAt.isBefore(end)) continue;
      if (_emotions[e.emotionId] == null) continue;
      final dayKey = normalizeDate(e.createdAt);
      final current = latestByDay[dayKey];
      if (current == null || e.createdAt.isAfter(current.createdAt)) {
        latestByDay[dayKey] = e;
      }
    }
    final result = <DateTime, Color>{};
    latestByDay.forEach((day, entry) {
      final quadrantId = _emotions[entry.emotionId]!.quadrantId;
      final quadrantLabel = _quadrants[quadrantId]?.label ?? '';
      result[day] = visualFor(quadrantLabel).color;
    });
    return result;
  }

  String _summaryFor(List<Entry> entries) {
    if (entries.isEmpty) {
      return '${_periodIntro()} rien encore enregistré. Prends le temps qu’il te faut.';
    }
    final counts = _emotionCounts(entries);
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = _emotions[sorted.first.key]?.name;
    final secondary =
        sorted.length > 1 ? _emotions[sorted[1].key]?.name : null;
    final tertiary =
        sorted.length > 2 ? _emotions[sorted[2].key]?.name : null;
    final intro = _periodIntro();
    final body = <String>['beaucoup ${partitiveDe(top ?? '')}'];
    if (secondary != null) {
      if (tertiary != null) {
        body.add('un peu ${partitiveDe(secondary)} et ${partitiveDe(tertiary)}');
      } else {
        body.add('un peu ${partitiveDe(secondary)}');
      }
    }
    return '$intro ${body.join(", ")}. Les hauts et les bas font partie de ces journées.';
  }

  String _periodIntro() {
    switch (_period) {
      case HistoryPeriod.week:
        return 'Cette semaine :';
      case HistoryPeriod.day:
        return 'Aujourd’hui :';
      case HistoryPeriod.month:
        return 'Ce mois :';
    }
  }

  @override
  Widget build(BuildContext context) {
    final periodEntries = _entriesInPeriod();
    final bubbles = _bubblesFor(periodEntries);
    final counts = _emotionCounts(periodEntries);
    final sortedCounts = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final now = DateTime.now();
    final monthLabel =
        '${frenchMonths[now.month - 1].toUpperCase()} ${now.year}';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mon historique',
                      style:
                          Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                    ),
                    const SizedBox(height: 16),
                    PeriodToggle(
                      value: _period,
                      onChanged: (p) => setState(() => _period = p),
                    ),
                    const SizedBox(height: 20),
                    Jar(
                      bubbles: bubbles,
                      onTap: (data) => _openEntry(data.id),
                      animateNewOnAppear: true,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _summaryFor(periodEntries),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      monthLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CalendarGrid(
                      month: now,
                      dayColors: _dayColorsForMonth(),
                      onDayTap: (day) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DayDetailScreen(day: day),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: const BottomNav(currentTab: MainTab.history),
    );
  }
}

class _CountTag extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _CountTag({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$label x $count',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
