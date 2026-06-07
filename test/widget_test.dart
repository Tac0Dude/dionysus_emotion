import 'package:flutter_test/flutter_test.dart';

import 'package:dionysus_emotion/presentation/onboarding/onboarding_state.dart';

void main() {
  test('OnboardingState canContinueFromCurrent — étape 0 toujours validable',
      () {
    const state = OnboardingState();
    expect(state.canContinueFromCurrent, isTrue);
  });

  test('OnboardingState canContinueFromCurrent — étape 1 exige un prénom', () {
    const empty = OnboardingState(currentStep: 1);
    const filled = OnboardingState(currentStep: 1, parentName: 'Marie');
    expect(empty.canContinueFromCurrent, isFalse);
    expect(filled.canContinueFromCurrent, isTrue);
  });

  test(
      'OnboardingState canContinueFromCurrent — étape 3 exige date et stage',
      () {
    final partial = OnboardingState(
      currentStep: 3,
      birthDate: DateTime(2026, 4, 3),
    );
    final complete = OnboardingState(
      currentStep: 3,
      birthDate: DateTime(2026, 4, 3),
      stageId: 1,
    );
    expect(partial.canContinueFromCurrent, isFalse);
    expect(complete.canContinueFromCurrent, isTrue);
  });
}
