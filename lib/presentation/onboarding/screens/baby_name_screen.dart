import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../onboarding_state.dart';
import '../widgets/cream_text_field.dart';

class BabyNameScreen extends ConsumerStatefulWidget {
  const BabyNameScreen({super.key});

  @override
  ConsumerState<BabyNameScreen> createState() => _BabyNameScreenState();
}

class _BabyNameScreenState extends ConsumerState<BabyNameScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: ref.read(onboardingProvider).babyName);
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
          'Et ton bébé?',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 40),
        CreamTextField(
          controller: _controller,
          label: 'prénom',
          autofocus: true,
          onChanged: ref.read(onboardingProvider.notifier).setBabyName,
          textInputAction: TextInputAction.done,
        ),
        const Spacer(),
      ],
    );
  }
}
