import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum QuadrantShape {
  circle,
  organic,
  roundedSquare,
  roundedRectangle,
}

class QuadrantVisual {
  final Color color;
  final QuadrantShape shape;
  final String shortLabel;
  final String subLabel;
  final bool isPositive;

  const QuadrantVisual({
    required this.color,
    required this.shape,
    required this.shortLabel,
    required this.subLabel,
    required this.isPositive,
  });
}

const _byLabel = <String, QuadrantVisual>{
  'Agréable et en contrôle': QuadrantVisual(
    color: AppColors.quadrantAgreableControle,
    shape: QuadrantShape.circle,
    shortLabel: 'Agréable',
    subLabel: 'et en contrôle',
    isPositive: true,
  ),
  'Agréable mais dépassé·e': QuadrantVisual(
    color: AppColors.quadrantAgreableDepasse,
    shape: QuadrantShape.organic,
    shortLabel: 'Agréable',
    subLabel: 'mais dépassé·e',
    isPositive: true,
  ),
  'Difficile mais en contrôle': QuadrantVisual(
    color: AppColors.quadrantDifficileControle,
    shape: QuadrantShape.roundedSquare,
    shortLabel: 'Difficile',
    subLabel: 'mais en contrôle',
    isPositive: false,
  ),
  'Difficile et dépassé·e': QuadrantVisual(
    color: AppColors.quadrantDifficileDepasse,
    shape: QuadrantShape.roundedRectangle,
    shortLabel: 'Difficile',
    subLabel: 'et dépassé·e',
    isPositive: false,
  ),
};

QuadrantVisual visualFor(String quadrantLabel) {
  return _byLabel[quadrantLabel] ??
      const QuadrantVisual(
        color: AppColors.primaryLight,
        shape: QuadrantShape.circle,
        shortLabel: '',
        subLabel: '',
        isPositive: true,
      );
}
