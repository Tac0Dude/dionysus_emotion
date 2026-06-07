import 'package:flutter/material.dart';

class IntensityDots extends StatelessWidget {
  final int intensity;
  final Color accent;
  final double scale;

  const IntensityDots({
    super.key,
    required this.intensity,
    required this.accent,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    const baseSizes = <double>[10, 14, 18, 22, 26];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(5, (i) {
        final level = i + 1;
        final selected = level == intensity;
        final size = baseSizes[i] * scale;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3 * scale),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? accent : accent.withValues(alpha: 0.35),
            ),
          ),
        );
      }),
    );
  }
}
