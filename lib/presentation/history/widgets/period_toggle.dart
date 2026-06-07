import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

enum HistoryPeriod { week, day, month }

class PeriodToggle extends StatelessWidget {
  final HistoryPeriod value;
  final ValueChanged<HistoryPeriod> onChanged;

  const PeriodToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(
          label: 'Semaine',
          selected: value == HistoryPeriod.week,
          onTap: () => onChanged(HistoryPeriod.week),
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'Jour',
          selected: value == HistoryPeriod.day,
          onTap: () => onChanged(HistoryPeriod.day),
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'Mois',
          selected: value == HistoryPeriod.month,
          onTap: () => onChanged(HistoryPeriod.month),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.cream : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(minHeight: 36),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
