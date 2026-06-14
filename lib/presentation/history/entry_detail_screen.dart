import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/entry.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/quadrant.dart';
import '../common/date_helpers.dart';
import '../common/intensity_labels.dart';
import '../entry/quadrant_visuals.dart';
import '../entry/sentence_provider.dart';
import '../entry/widgets/quadrant_tile.dart';
import '../shell/bottom_nav.dart';
import '../theme/app_colors.dart';
import 'widgets/intensity_dots.dart';

class EntryDetailScreen extends ConsumerStatefulWidget {
  final Entry entry;

  const EntryDetailScreen({super.key, required this.entry});

  @override
  ConsumerState<EntryDetailScreen> createState() =>
      _EntryDetailScreenState();
}

class _EntryDetailScreenState extends ConsumerState<EntryDetailScreen> {
  Emotion? _emotion;
  Quadrant? _quadrant;
  Activity? _activity;
  Location? _location;
  String? _sentence;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(referenceRepositoryProvider);
    final emotion = await repo.getEmotion(widget.entry.emotionId);
    final quadrant =
        emotion != null ? await repo.getQuadrant(emotion.quadrantId) : null;
    final activity = widget.entry.activityId != null
        ? await repo.getActivity(widget.entry.activityId!)
        : null;
    final location = widget.entry.locationId != null
        ? await repo.getLocation(widget.entry.locationId!)
        : null;
    final sentences = await ref.read(sentencesProvider.future);
    if (!mounted) return;
    setState(() {
      _emotion = emotion;
      _quadrant = quadrant;
      _activity = activity;
      _location = location;
      _sentence = emotion != null
          ? pickSentenceFor(sentences, emotion.name,
              random: Random(widget.entry.id))
          : null;
      _loading = false;
    });
  }

  String _formatDate(DateTime d) {
    final weekday = frenchWeekdays[d.weekday - 1];
    return '$weekday ${d.day} ${frenchMonths[d.month - 1]} ${d.year}';
  }

  String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const BackButton(color: AppColors.textPrimary),
        title: const Text(
          'Mon historique',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        top: false,
        child: _loading || _emotion == null || _quadrant == null
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _buildContent(),
      ),
      bottomNavigationBar: const BottomNav(currentTab: MainTab.history),
    );
  }

  Widget _buildContent() {
    final emotion = _emotion!;
    final quadrant = _quadrant!;
    final visual = visualFor(quadrant.label);
    final entry = widget.entry;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              width: 160,
              height: 160,
              child: QuadrantShapeBox(
                shape: visual.shape,
                color: visual.color,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      emotion.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              quadrant.label,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: IntensityDots(
              intensity: entry.intensity,
              accent: visual.color,
              scale: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              intensityLabels[entry.intensity - 1],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _DetailsCard(
            rows: [
              ('Date', _formatDate(entry.createdAt)),
              ('Heure', _formatTime(entry.createdAt)),
              if (_activity != null) ('Activité', _activity!.label),
              if (_location != null) ('Lieu', _location!.label),
            ],
          ),
          if (_sentence != null) ...[
            const SizedBox(height: 20),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              decoration: BoxDecoration(
                color: visual.color.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _sentence!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final List<(String, String)> rows;

  const _DetailsCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Text(
                    rows[i].$1,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      rows[i].$2,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < rows.length - 1)
              const Divider(height: 1, indent: 18, endIndent: 18),
          ],
        ],
      ),
    );
  }
}
