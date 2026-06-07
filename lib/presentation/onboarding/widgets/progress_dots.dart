import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class ProgressDots extends StatelessWidget {
  final int total;
  final int currentIndex;

  const ProgressDots({
    super.key,
    required this.total,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == currentIndex;
        final isCompleted = index < currentIndex;
        final color = isActive
            ? AppColors.primary
            : isCompleted
                ? AppColors.primaryLight
                : AppColors.dotInactive;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
