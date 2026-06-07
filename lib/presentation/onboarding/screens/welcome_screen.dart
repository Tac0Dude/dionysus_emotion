import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.favorite,
          size: 96,
          color: AppColors.primaryLight,
        ),
        const SizedBox(height: 40),
        Text(
          'Bienvenue',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Un espace pour suivre ton vécu émotionnel, jour après jour.',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
