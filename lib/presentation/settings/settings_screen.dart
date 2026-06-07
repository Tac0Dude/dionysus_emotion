import 'package:flutter/material.dart';

import '../shell/bottom_nav.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Paramètres',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'Cette section arrive bientôt.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentTab: MainTab.settings),
    );
  }
}
