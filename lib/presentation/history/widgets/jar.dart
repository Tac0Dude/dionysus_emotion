import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../entry/quadrant_visuals.dart';
import '../../theme/app_colors.dart';

class EmotionBubbleData {
  final int id;
  final String emotionName;
  final QuadrantShape shape;
  final Color color;
  final int intensity;

  const EmotionBubbleData({
    required this.id,
    required this.emotionName,
    required this.shape,
    required this.color,
    required this.intensity,
  });
}

const _bubbleSizes = <double>[40, 52, 64, 78, 92];

class _Placed {
  final EmotionBubbleData data;
  final double x;
  final double yFromBottom;
  final double size;
  const _Placed({
    required this.data,
    required this.x,
    required this.yFromBottom,
    required this.size,
  });
}

class Jar extends StatelessWidget {
  final List<EmotionBubbleData> bubbles;
  final void Function(EmotionBubbleData) onTap;

  const Jar({
    super.key,
    required this.bubbles,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 26,
              decoration: const BoxDecoration(
                color: Color(0xFF2D2826),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(8)),
              ),
            ),
            Container(
              width: 230,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF2D2826),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(4)),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 220),
            padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.divider, width: 1),
            ),
            child: bubbles.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Text(
                        'Pas encore de saisie sur cette période.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final placed = _pack(bubbles, width);
                      final pileHeight = placed.isEmpty
                          ? 0.0
                          : placed
                              .map((p) => p.yFromBottom + p.size)
                              .reduce(math.max);
                      final stackHeight = math.max(pileHeight, 180.0);
                      return SizedBox(
                        width: width,
                        height: stackHeight,
                        child: Stack(
                          clipBehavior: Clip.hardEdge,
                          children: placed.map((p) {
                            return Positioned(
                              left: p.x,
                              top: stackHeight - p.yFromBottom - p.size,
                              width: p.size,
                              height: p.size,
                              child: _Bubble(
                                placed: p,
                                onTap: () => onTap(p.data),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  List<_Placed> _pack(List<EmotionBubbleData> bubbles, double width) {
    if (width <= 0 || bubbles.isEmpty) return const [];

    // Les grosses bulles (intensité forte) se tassent au fond en premier ; les
    // plus petites comblent ensuite les creux. Tri stable pour un rendu figé.
    final sorted = [...bubbles]..sort((a, b) {
        final c = b.intensity.compareTo(a.intensity);
        if (c != 0) return c;
        return a.id.compareTo(b.id);
      });

    final w = width.floor();
    // skyline[k] = hauteur déjà remplie à la colonne k (depuis le bas).
    final skyline = List<double>.filled(w, 0.0);
    final placed = <_Placed>[];
    final center = w / 2;

    for (final bubble in sorted) {
      final size = _bubbleSizes[bubble.intensity - 1];
      final span = size.ceil();

      // Bulle plus large que le bocal : on la pose à plat au-dessus du tas.
      if (span >= w) {
        final base = skyline.reduce(math.max);
        for (var k = 0; k < w; k++) {
          skyline[k] = base + size;
        }
        placed.add(_Placed(data: bubble, x: 0, yFromBottom: base, size: size));
        continue;
      }

      // Comportement « liquide » : on cherche la position dont la base est la
      // plus basse (remplit le creux le plus profond avant de monter). À base
      // égale, on privilégie le centre pour former un tas naturel.
      final maxStart = w - span;
      var bestBase = double.infinity;
      var bestX = 0;
      var bestCenterDist = double.infinity;

      for (var x = 0; x <= maxStart; x++) {
        var base = 0.0;
        for (var k = x; k < x + span; k++) {
          if (skyline[k] > base) base = skyline[k];
        }
        final centerDist = (x + span / 2 - center).abs();
        if (base < bestBase - 0.5 ||
            (base <= bestBase + 0.5 && centerDist < bestCenterDist)) {
          bestBase = base;
          bestX = x;
          bestCenterDist = centerDist;
        }
      }

      final newTop = bestBase + size;
      for (var k = bestX; k < bestX + span; k++) {
        skyline[k] = newTop;
      }
      placed.add(_Placed(
        data: bubble,
        x: bestX.toDouble(),
        yFromBottom: bestBase,
        size: size,
      ));
    }
    return placed;
  }
}

class _Bubble extends StatelessWidget {
  final _Placed placed;
  final VoidCallback onTap;

  const _Bubble({required this.placed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final data = placed.data;
    final size = placed.size;
    final border = _shapeBorder(data.shape, size);
    return Material(
      color: data.color,
      shape: border,
      child: InkWell(
        onTap: onTap,
        customBorder: border,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(size * 0.12),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  data.emotionName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ShapeBorder _shapeBorder(QuadrantShape shape, double size) {
    switch (shape) {
      case QuadrantShape.circle:
        return const CircleBorder();
      case QuadrantShape.roundedSquare:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size * 0.26),
        );
      case QuadrantShape.roundedRectangle:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size * 0.42),
        );
      case QuadrantShape.organic:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size * 0.36),
        );
    }
  }
}
