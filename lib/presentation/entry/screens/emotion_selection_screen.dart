import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../domain/entities/emotion.dart';
import '../../../domain/entities/quadrant.dart';
import '../../shell/bottom_nav.dart';
import '../../theme/app_colors.dart';
import '../quadrant_visuals.dart';
import 'intensity_screen.dart';

class EmotionSelectionScreen extends ConsumerStatefulWidget {
  final Quadrant quadrant;

  const EmotionSelectionScreen({super.key, required this.quadrant});

  @override
  ConsumerState<EmotionSelectionScreen> createState() =>
      _EmotionSelectionScreenState();
}

class _EmotionSelectionScreenState
    extends ConsumerState<EmotionSelectionScreen> {
  List<Emotion> _emotions = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final emotions = await ref
        .read(referenceRepositoryProvider)
        .getEmotionsForQuadrant(widget.quadrant.id);
    if (!mounted) return;
    setState(() {
      _emotions = emotions;
      _loading = false;
    });
  }

  void _openIntensity(Emotion emotion) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => IntensityScreen(
          quadrant: widget.quadrant,
          emotion: emotion,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visual = visualFor(widget.quadrant.label);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Column(
          children: [
            Text(
              visual.shortLabel,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              visual.subLabel,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNav(currentTab: MainTab.entry),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : Column(
                  children: [
                    Text(
                      'Quelle émotion\nte correspond\nle mieux?',
                      textAlign: TextAlign.center,
                      style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Expanded(
                      child: ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        itemCount: _emotions.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final emotion = _emotions[index];
                          return _EmotionCard(
                            label: emotion.name,
                            color: visual.color,
                            onTap: () => _openIntensity(emotion),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _EmotionCard extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _EmotionCard({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 64,
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
