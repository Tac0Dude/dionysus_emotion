import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../onboarding_state.dart';
import '../widgets/cream_text_field.dart';

class ParentNameScreen extends ConsumerStatefulWidget {
  const ParentNameScreen({super.key});

  @override
  ConsumerState<ParentNameScreen> createState() => _ParentNameScreenState();
}

class _ParentNameScreenState extends ConsumerState<ParentNameScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: ref.read(onboardingProvider).parentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Comment tu\nt’appelles?',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Pour personnaliser ton expérience',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 28),
        CreamTextField(
          controller: _controller,
          label: 'prénom',
          autofocus: true,
          onChanged: ref.read(onboardingProvider.notifier).setParentName,
        ),
        const Spacer(),
      ],
    );
  }
}
