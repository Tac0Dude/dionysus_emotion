import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CreamTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final bool autofocus;

  const CreamTextField({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
    this.onClear,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.words,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextField(
          controller: controller,
          onChanged: onChanged,
          autofocus: autofocus,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(
                      Icons.cancel,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      controller.clear();
                      onClear?.call();
                      onChanged?.call('');
                    },
                  ),
          ),
        );
      },
    );
  }
}
