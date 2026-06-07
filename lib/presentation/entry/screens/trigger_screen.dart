import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../domain/entities/activity.dart';
import '../../../domain/entities/emotion.dart';
import '../../../domain/entities/location.dart';
import '../../../domain/entities/quadrant.dart';
import '../../shell/bottom_nav.dart';
import '../../theme/app_colors.dart';
import '../sentence_provider.dart';
import '../widgets/trigger_chips.dart';
import 'validation_screen.dart';

class TriggerScreen extends ConsumerStatefulWidget {
  final Quadrant quadrant;
  final Emotion emotion;
  final int intensity;

  const TriggerScreen({
    super.key,
    required this.quadrant,
    required this.emotion,
    required this.intensity,
  });

  @override
  ConsumerState<TriggerScreen> createState() => _TriggerScreenState();
}

class _TriggerScreenState extends ConsumerState<TriggerScreen> {
  int? _activityId;
  int? _locationId;
  List<Activity> _activities = const [];
  List<Location> _locations = const [];
  bool _loading = true;
  bool _submitting = false;

  static const _intensityLabels = <String>[
    'légère',
    'faible',
    'modérée',
    'forte',
    'intense',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(referenceRepositoryProvider);
    final results = await Future.wait([
      repo.getActivities(),
      repo.getLocations(),
    ]);
    if (!mounted) return;
    setState(() {
      _activities = results[0] as List<Activity>;
      _locations = results[1] as List<Location>;
      _loading = false;
    });
  }

  Future<void> _onSave() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final parent =
        await ref.read(parentRepositoryProvider).getCurrentParent();
    if (parent == null) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil parent introuvable. Recommence l’onboarding.'),
        ),
      );
      return;
    }

    try {
      await ref.read(entryRepositoryProvider).createEntry(
            parentId: parent.id,
            emotionId: widget.emotion.id,
            intensity: widget.intensity,
            activityId: _activityId,
            locationId: _locationId,
          );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible d’enregistrer : $e')),
      );
      return;
    }

    final sentences = await ref.read(sentencesProvider.future);
    if (!mounted) return;
    final sentence =
        pickSentenceFor(sentences, widget.emotion.name, random: Random());

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ValidationScreen(
          quadrant: widget.quadrant,
          emotion: widget.emotion,
          intensity: widget.intensity,
          sentence: sentence,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final intensityLabel = _intensityLabels[widget.intensity - 1];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text(
          intensityLabel,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNav(currentTab: MainTab.entry),
      body: SafeArea(
        bottom: false,
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Column(
                  children: [
                    Text(
                      'Qu’est-ce qui a\ndéclenché cette\némotion?',
                      textAlign: TextAlign.center,
                      style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Optionnel',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TriggerChipsSection<Activity>(
                              title: 'Activités',
                              items: _activities,
                              label: (a) => a.label,
                              idOf: (a) => a.id,
                              selectedId: _activityId,
                              onSelected: (id) =>
                                  setState(() => _activityId = id),
                            ),
                            const SizedBox(height: 24),
                            TriggerChipsSection<Location>(
                              title: 'Lieux',
                              items: _locations,
                              label: (l) => l.label,
                              idOf: (l) => l.id,
                              selectedId: _locationId,
                              onSelected: (id) =>
                                  setState(() => _locationId = id),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _onSave,
                        child: _submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Enregistrer'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
