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

    // Stable seed so the layout doesn't jump around between rebuilds.
    final seed = bubbles.fold<int>(17, (acc, b) => acc * 31 + b.id);
    final random = math.Random(seed);

    // Big bubbles settle first so smaller ones can perch on top.
    final sorted = [...bubbles]..sort((a, b) {
        final c = b.intensity.compareTo(a.intensity);
        if (c != 0) return c;
        return b.id.compareTo(a.id);
      });

    final w = width.floor();
    final skyline = List<double>.filled(w, 0.0);
    final placed = <_Placed>[];

    for (final bubble in sorted) {
      final size = _bubbleSizes[bubble.intensity - 1];
      final span = size.ceil();
      if (span > w) continue;

      // Pick a random horizontal position; the bubble falls straight down
      // from there and rests on whatever it meets first.
      final maxStart = w - span;
      final startX = maxStart > 0 ? random.nextInt(maxStart + 1) : 0;
      var localMax = 0.0;
      for (var k = startX; k < startX + span; k++) {
        if (skyline[k] > localMax) localMax = skyline[k];
      }
      final newTop = localMax + size;
      for (var k = startX; k < startX + span; k++) {
        skyline[k] = newTop;
      }
      placed.add(_Placed(
        data: bubble,
        x: startX.toDouble(),
        yFromBottom: localMax,
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
