import 'package:flutter/material.dart';

import '../../../domain/entities/emotion.dart';
import '../../../domain/entities/quadrant.dart';
import '../../shell/bottom_nav.dart';
import '../../theme/app_colors.dart';
import '../emotion_articles.dart';
import '../quadrant_visuals.dart';
import '../widgets/validation_header.dart';

class ValidationScreen extends StatefulWidget {
  final Quadrant quadrant;
  final Emotion emotion;
  final int intensity;
  final String sentence;

  const ValidationScreen({
    super.key,
    required this.quadrant,
    required this.emotion,
    required this.intensity,
    required this.sentence,
  });

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _close() {
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final visual = visualFor(widget.quadrant.label);
    final isPositive = visual.isPositive;
    final showResources = !isPositive && widget.intensity >= 4;

    final title = isPositive
        ? 'Je ressens ${articleFor(widget.emotion.name)}'
        : 'Je reconnais ce\nque je ressens';
    final subtitle = isPositive
        ? emotionNameForDisplay(widget.emotion.name)
        : widget.emotion.name;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNav(currentTab: MainTab.entry),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _close,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValidationHeader(
              color: visual.color,
              title: title,
              subtitle: subtitle,
              emphasizeSubtitle: isPositive,
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        widget.sentence,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                      const Spacer(),
                      if (showResources) _ResourceList(),
                      const SizedBox(height: 16),
                      FadeTransition(
                        opacity: Tween<double>(begin: 0.35, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _pulseController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: const Text(
                          'Presser pour continuer…',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Tu veux en parler à\nquelqu’un?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const _ResourceTile(
          icon: Icons.favorite_outline,
          label: 'Né Trop Tôt — Parents bénévoles',
        ),
        const _ResourceTile(
          icon: Icons.person_outline,
          label: 'Pédopsychiatrie CHUV',
        ),
        const _ResourceTile(
          icon: Icons.forum_outlined,
          label: 'Parler à l’équipe soignante',
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ResourceTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ResourceTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.textPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
