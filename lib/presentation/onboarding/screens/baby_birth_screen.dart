import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../domain/entities/stage.dart';
import '../../theme/app_colors.dart';
import '../onboarding_state.dart';

class BabyBirthScreen extends ConsumerStatefulWidget {
  const BabyBirthScreen({super.key});

  @override
  ConsumerState<BabyBirthScreen> createState() => _BabyBirthScreenState();
}

class _BabyBirthScreenState extends ConsumerState<BabyBirthScreen> {
  List<Stage> _stages = const [];
  bool _loadingStages = true;

  @override
  void initState() {
    super.initState();
    _loadStages();
  }

  Future<void> _loadStages() async {
    final repo = ref.read(referenceRepositoryProvider);
    final stages = await repo.getStages();
    if (!mounted) return;
    setState(() {
      _stages = stages;
      _loadingStages = false;
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final state = ref.read(onboardingProvider);
    final now = DateTime.now();
    final initial = state.birthDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      helpText: 'Date de naissance',
      cancelText: 'Annuler',
      confirmText: 'OK',
    );
    if (picked != null) {
      ref.read(onboardingProvider.notifier).setBirthDate(picked);
    }
  }

  String _formatDate(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    return '$dd/$mm/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    final babyName = state.babyName.trim().isEmpty ? 'bébé' : state.babyName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quand est né $babyName?',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 20),
        _DateField(
          value: state.birthDate,
          onTap: () => _pickDate(context),
          formatter: _formatDate,
        ),
        const SizedBox(height: 32),
        Text(
          'A combien de semaines?',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _WeeksSlider(
          value: state.gestationalWeeks,
          onChanged: notifier.setGestationalWeeks,
        ),
        const SizedBox(height: 24),
        Text(
          'Situation actuelle',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (_loadingStages)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else
          Column(
            children: _stages
                .map(
                  (stage) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _StageCard(
                      stage: stage,
                      selected: state.stageId == stage.id,
                      onTap: () => notifier.setStage(stage.id),
                    ),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime? value;
  final VoidCallback onTap;
  final String Function(DateTime) formatter;

  const _DateField({
    required this.value,
    required this.onTap,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 1.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              color: AppColors.cream,
              child: Text(
                'Date',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value != null ? formatter(value!) : 'jj/mm/yyyy',
              style: TextStyle(
                fontSize: 18,
                color: value != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeksSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _WeeksSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const min = OnboardingState.minWeeks;
    const max = OnboardingState.maxWeeks;
    return Column(
      children: [
        Row(
          children: [
            Text(
              '$min',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  showValueIndicator: ShowValueIndicator.onDrag,
                ),
                child: Slider(
                  value: value.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: max - min,
                  label: '$value sem',
                  onChanged: (v) => onChanged(v.round()),
                ),
              ),
            ),
            Text(
              '$max',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          '$value sem',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StageCard extends StatelessWidget {
  final Stage stage;
  final bool selected;
  final VoidCallback onTap;

  const _StageCard({
    required this.stage,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.cream : AppColors.cream.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 1.4,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  stage.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
