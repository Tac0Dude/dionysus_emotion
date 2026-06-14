import 'package:flutter/material.dart';

import '../../common/intensity_labels.dart';
import '../../theme/app_colors.dart';

class IntensityPicker extends StatelessWidget {
  final int? value;
  final ValueChanged<int> onChanged;
  final Color accent;

  const IntensityPicker({
    super.key,
    required this.value,
    required this.onChanged,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    const sizes = <double>[18, 28, 38, 48, 58];
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(5, (index) {
          final level = index + 1;
          final selected = value == level;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(level),
              child: SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: sizes[index],
                      height: sizes[index],
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected ? accent : Colors.transparent,
                        border: Border.all(
                          color: selected ? accent : AppColors.textSecondary,
                          width: 1.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      intensityLabels[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
