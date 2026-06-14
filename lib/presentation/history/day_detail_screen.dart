import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/entry.dart';
import '../common/date_helpers.dart';
import '../common/intensity_labels.dart';
import '../entry/quadrant_visuals.dart';
import '../shell/bottom_nav.dart';
import '../theme/app_colors.dart';
import 'entry_detail_screen.dart';
import 'widgets/intensity_dots.dart';

class DayDetailScreen extends ConsumerStatefulWidget {
  final DateTime day;

  const DayDetailScreen({super.key, required this.day});

  @override
  ConsumerState<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends ConsumerState<DayDetailScreen> {
  bool _loading = true;
  List<Entry> _entries = const [];
  Map<int, Emotion> _emotions = const {};
  Map<int, String> _quadrantLabelByEmotion = const {};
  Map<int, Activity> _activities = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final parent =
        await ref.read(parentRepositoryProvider).getCurrentParent();
    if (parent == null) {
      if (!mounted) return;
      setState(() => _loading = false);
      return;
    }
    final entries = await ref.read(entryRepositoryProvider).getForDay(
          parentId: parent.id,
          day: widget.day,
        );
    final refRepo = ref.read(referenceRepositoryProvider);
    final allEmotions = await refRepo.getAllEmotions();
    final quadrants = await refRepo.getQuadrants();
    final activities = await refRepo.getActivities();

    final emotionsById = {for (final e in allEmotions) e.id: e};
    final quadrantLabelByEmotion = <int, String>{
      for (final e in allEmotions)
        e.id: quadrants
            .firstWhere(
              (q) => q.id == e.quadrantId,
              orElse: () => quadrants.first,
            )
            .label
    };
    final activitiesById = {for (final a in activities) a.id: a};
    if (!mounted) return;
    setState(() {
      _entries = entries;
      _emotions = emotionsById;
      _quadrantLabelByEmotion = quadrantLabelByEmotion;
      _activities = activitiesById;
      _loading = false;
    });
  }

  String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  String _formatDayTitle(DateTime d) {
    final weekday = frenchWeekdays[d.weekday - 1];
    return '$weekday ${d.day} ${frenchMonths[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const BackButton(color: AppColors.textPrimary),
        title: const Text(
          'Mon historique',
          style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        ),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        top: false,
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDayTitle(widget.day),
                      style:
                          Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _entries.isEmpty
                          ? 'Aucune saisie'
                          : '${_entries.length} saisie${_entries.length > 1 ? "s" : ""}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: _entries.isEmpty
                          ? const _EmptyState()
                          : ListView.separated(
                              physics: const ClampingScrollPhysics(),
                              itemCount: _entries.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final entry = _entries[index];
                                final emotion = _emotions[entry.emotionId];
                                if (emotion == null) {
                                  return const SizedBox.shrink();
                                }
                                final quadrantLabel =
                                    _quadrantLabelByEmotion[emotion.id] ?? '';
                                final visual = visualFor(quadrantLabel);
                                final activity = entry.activityId != null
                                    ? _activities[entry.activityId!]
                                    : null;
                                return _EntryCard(
                                  emotionName: emotion.name,
                                  intensity: entry.intensity,
                                  time: _formatTime(entry.createdAt),
                                  accent: visual.color,
                                  activityLabel: activity?.label,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            EntryDetailScreen(entry: entry),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: const BottomNav(currentTab: MainTab.history),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Pas de saisie pour ce jour.',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final String emotionName;
  final int intensity;
  final String time;
  final Color accent;
  final String? activityLabel;
  final VoidCallback onTap;

  const _EntryCard({
    required this.emotionName,
    required this.intensity,
    required this.time,
    required this.accent,
    required this.activityLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cream,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    emotionName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IntensityDots(
                    intensity: intensity,
                    accent: accent,
                    scale: 0.85,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    intensityLabels[intensity - 1].toLowerCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (activityLabel != null)
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.divider,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            activityLabel!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
