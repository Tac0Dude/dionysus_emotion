import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../quadrant_visuals.dart';
import 'quadrant_tile.dart';

/// Tuile de quadrant agrémentée de **contours flottants** : des échos de la
/// silhouette de la forme s'écartent doucement et s'estompent en boucle, et la
/// tuile flotte légèrement. Rend l'écran de sélection plus vivant sans détourner
/// l'attention (mouvement lent, faible opacité).
class AnimatedQuadrantTile extends StatefulWidget {
  final QuadrantVisual visual;
  final VoidCallback onTap;

  /// Décalage de phase (0..1) pour désynchroniser les tuiles entre elles.
  final double phase;

  const AnimatedQuadrantTile({
    super.key,
    required this.visual,
    required this.onTap,
    this.phase = 0,
  });

  @override
  State<AnimatedQuadrantTile> createState() => _AnimatedQuadrantTileState();
}

class _AnimatedQuadrantTileState extends State<AnimatedQuadrantTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Path? _cachedPath;
  Size? _cachedSize;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Path _pathFor(Size size) {
    if (_cachedPath != null && _cachedSize == size) return _cachedPath!;
    _cachedSize = size;
    _cachedPath = quadrantShapePath(widget.visual.shape, size);
    return _cachedPath!;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          final path = _pathFor(size);
          return AnimatedBuilder(
            animation: _controller,
            child: QuadrantTile(visual: widget.visual, onTap: widget.onTap),
            builder: (context, child) {
              final echoT = (_controller.value + widget.phase) % 1.0;
              // Les formes restent immobiles ; seuls les contours « vaguelettes »
              // s'écartent et s'estompent autour d'elles.
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _FloatingOutlinesPainter(
                          path: path,
                          color: widget.visual.color,
                          t: echoT,
                        ),
                      ),
                    ),
                  ),
                  child!,
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// Échos de contour qui s'écartent du centre et s'estompent, façon ondes.
class _FloatingOutlinesPainter extends CustomPainter {
  final Path path;
  final Color color;
  final double t;

  static const _echoes = 2;

  _FloatingOutlinesPainter({
    required this.path,
    required this.color,
    required this.t,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final a = 2 * math.pi * t;
    for (var k = 0; k < _echoes; k++) {
      final phase = (t + k / _echoes) % 1.0;
      final scale = 1.0 + 0.14 * phase;
      final opacity = (1 - phase) * 0.35;
      if (opacity <= 0.01) continue;

      // Oscillation 2D des vaguelettes : X à 1 cycle, Y à 2 cycles (amplitude
      // verticale plus marquée) → mouvement haut/bas et diagonale. Échos en
      // opposition de phase (k·π) pour varier. Bouclé sans à-coup.
      final drift = Offset(
        math.sin(a + k * math.pi) * 7,
        math.sin(2 * a + k * math.pi) * 10,
      );

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = color.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(center.dx + drift.dx, center.dy + drift.dy);
      canvas.scale(scale);
      canvas.translate(-center.dx, -center.dy);
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_FloatingOutlinesPainter old) =>
      old.t != t || old.color != color || old.path != path;
}
