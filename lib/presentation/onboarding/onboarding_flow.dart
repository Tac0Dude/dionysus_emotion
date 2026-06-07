import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import 'onboarding_state.dart';
import 'screens/baby_birth_screen.dart';
import 'screens/baby_name_screen.dart';
import 'screens/confirmation_screen.dart';
import 'screens/parent_name_screen.dart';
import 'screens/welcome_screen.dart';
import 'widgets/onboarding_scaffold.dart';

class OnboardingFlow extends ConsumerWidget {
  const OnboardingFlow({super.key});

  Widget _screenFor(int step) {
    switch (step) {
      case 0:
        return const WelcomeScreen();
      case 1:
        return const ParentNameScreen();
      case 2:
        return const BabyNameScreen();
      case 3:
        return const BabyBirthScreen();
      case 4:
        return const ConfirmationScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _onContinue(BuildContext context, WidgetRef ref) async {
    final state = ref.read(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    if (state.currentStep < OnboardingState.totalSteps - 1) {
      FocusScope.of(context).unfocus();
      notifier.next();
      return;
    }

    if (state.submitting) return;
    if (state.birthDate == null || state.stageId == null) return;

    notifier.setSubmitting(true);
    try {
      await ref.read(parentRepositoryProvider).createParent(
            firstName: state.parentName.trim(),
            babyFirstName: state.babyName.trim(),
            babyBirthDate: state.birthDate!,
            gestationalAgeWeeks: state.gestationalWeeks,
            stageId: state.stageId!,
          );
    } catch (e) {
      notifier.setSubmitting(false);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible d’enregistrer : $e')),
      );
      return;
    }
    notifier.setSubmitting(false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final isLast = state.currentStep == OnboardingState.totalSteps - 1;

    return PopScope(
      canPop: state.currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        ref.read(onboardingProvider.notifier).back();
      },
      child: OnboardingScaffold(
        currentStep: state.currentStep,
        buttonLabel: isLast ? 'Commencer' : 'Continuer',
        loading: state.submitting,
        onContinue: state.canContinueFromCurrent
            ? () => _onContinue(context, ref)
            : null,
        child: _screenFor(state.currentStep),
      ),
    );
  }
}
