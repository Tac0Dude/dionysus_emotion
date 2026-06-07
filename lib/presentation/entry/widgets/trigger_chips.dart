import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class TriggerChipsSection<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final String Function(T) label;
  final int Function(T) idOf;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  const TriggerChipsSection({
    super.key,
    required this.title,
    required this.items,
    required this.label,
    required this.idOf,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final id = idOf(item);
            final selected = id == selectedId;
            return _Chip(
              label: label(item),
              selected: selected,
              onTap: () => onSelected(selected ? null : id),
            );
          }).toList(),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
              width: selected ? 1.4 : 1,
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
