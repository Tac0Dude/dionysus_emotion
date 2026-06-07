import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingState {
  static const int totalSteps = 5;
  static const int minWeeks = 22;
  static const int maxWeeks = 36;

  final int currentStep;
  final String parentName;
  final String babyName;
  final DateTime? birthDate;
  final int gestationalWeeks;
  final int? stageId;
  final bool submitting;

  const OnboardingState({
    this.currentStep = 0,
    this.parentName = '',
    this.babyName = '',
    this.birthDate,
    this.gestationalWeeks = 28,
    this.stageId,
    this.submitting = false,
  });

  bool get canContinueFromCurrent {
    switch (currentStep) {
      case 0:
        return true;
      case 1:
        return parentName.trim().isNotEmpty;
      case 2:
        return babyName.trim().isNotEmpty;
      case 3:
        return birthDate != null && stageId != null;
      case 4:
        return !submitting;
      default:
        return false;
    }
  }

  OnboardingState copyWith({
    int? currentStep,
    String? parentName,
    String? babyName,
    DateTime? birthDate,
    int? gestationalWeeks,
    int? stageId,
    bool? submitting,
    bool clearBirthDate = false,
    bool clearStageId = false,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      parentName: parentName ?? this.parentName,
      babyName: babyName ?? this.babyName,
      birthDate: clearBirthDate ? null : (birthDate ?? this.birthDate),
      gestationalWeeks: gestationalWeeks ?? this.gestationalWeeks,
      stageId: clearStageId ? null : (stageId ?? this.stageId),
      submitting: submitting ?? this.submitting,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  void next() {
    if (state.currentStep < OnboardingState.totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void back() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void setParentName(String value) =>
      state = state.copyWith(parentName: value);

  void setBabyName(String value) => state = state.copyWith(babyName: value);

  void setBirthDate(DateTime value) =>
      state = state.copyWith(birthDate: value);

  void setGestationalWeeks(int value) =>
      state = state.copyWith(gestationalWeeks: value);

  void setStage(int stageId) => state = state.copyWith(stageId: stageId);

  void setSubmitting(bool value) =>
      state = state.copyWith(submitting: value);
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(),
);
