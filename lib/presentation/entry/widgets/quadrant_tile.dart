import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../quadrant_visuals.dart';

class QuadrantTile extends StatelessWidget {
  final QuadrantVisual visual;
  final VoidCallback onTap;

  const QuadrantTile({
    super.key,
    required this.visual,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${visual.shortLabel} ${visual.subLabel}',
      child: InkWell(
        onTap: onTap,
        customBorder: _borderForShape(visual.shape),
        child: AspectRatio(
          aspectRatio: 1,
          child: QuadrantShapeBox(
            shape: visual.shape,
            color: visual.color,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    visual.shortLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    visual.subLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ShapeBorder _borderForShape(QuadrantShape shape) {
    switch (shape) {
      case QuadrantShape.circle:
        return const CircleBorder();
      case QuadrantShape.roundedSquare:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(36));
      case QuadrantShape.roundedRectangle:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(56));
      case QuadrantShape.organic:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(40));
    }
  }
}

class QuadrantShapeBox extends StatelessWidget {
  final QuadrantShape shape;
  final Color color;
  final Widget child;

  const QuadrantShapeBox({
    super.key,
    required this.shape,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    switch (shape) {
      case QuadrantShape.circle:
        return DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: child,
        );
      case QuadrantShape.roundedSquare:
        return DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(36),
          ),
          child: child,
        );
      case QuadrantShape.roundedRectangle:
        // Quadrant bleu (Difficile et dépassé·e) : deux pilules empilées,
        // identiques au rendu du bocal de l'historique.
        return _StackedPills(color: color, child: child);
      case QuadrantShape.organic:
        return CustomPaint(
          painter: _OrganicShapePainter(color: color),
          child: child,
        );
    }
  }
}

/// Deux pilules (capsules) empilées, qui se recouvrent légèrement au centre
/// pour garder le contenu lisible. Silhouette du quadrant « Difficile et
/// dépassé·e », alignée sur le bocal de l'historique.
class _StackedPills extends StatelessWidget {
  final Color color;
  final Widget child;

  const _StackedPills({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final box =
            constraints.hasBoundedHeight ? constraints.maxHeight : constraints.maxWidth;
        final pillHeight = box * 0.54;
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: pillHeight,
              child: _pill(pillHeight),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: pillHeight,
              child: _pill(pillHeight),
            ),
            Positioned.fill(child: child),
          ],
        );
      },
    );
  }

  Widget _pill(double height) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}

class _OrganicShapePainter extends CustomPainter {
  final Color color;
  _OrganicShapePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final r = size.shortestSide * 0.30;
    final cx = size.width / 2;
    final cy = size.height / 2;
    // Quatre lobes symétriques + un cœur central : silhouette équilibrée,
    // inscrite dans un carré (largeur ≈ hauteur).
    final d = r * 0.5;
    canvas.drawCircle(Offset(cx - d, cy - d), r * 1.05, paint);
    canvas.drawCircle(Offset(cx + d, cy - d), r * 1.05, paint);
    canvas.drawCircle(Offset(cx - d, cy + d), r * 1.05, paint);
    canvas.drawCircle(Offset(cx + d, cy + d), r * 1.05, paint);
    canvas.drawCircle(Offset(cx, cy), r * 1.2, paint);
  }

  @override
  bool shouldRepaint(_OrganicShapePainter oldDelegate) =>
      oldDelegate.color != color;
}
