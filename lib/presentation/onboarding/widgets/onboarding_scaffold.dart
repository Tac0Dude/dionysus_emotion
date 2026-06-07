import 'package:flutter/material.dart';

import '../onboarding_state.dart';
import 'primary_button.dart';
import 'progress_dots.dart';

class OnboardingScaffold extends StatelessWidget {
  final int currentStep;
  final Widget child;
  final String buttonLabel;
  final VoidCallback? onContinue;
  final bool loading;

  const OnboardingScaffold({
    super.key,
    required this.currentStep,
    required this.child,
    required this.onContinue,
    this.buttonLabel = 'Continuer',
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              ProgressDots(
                total: OnboardingState.totalSteps,
                currentIndex: currentStep,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: KeyedSubtree(
                              key: ValueKey<int>(currentStep),
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: buttonLabel,
                onPressed: onContinue,
                loading: loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
