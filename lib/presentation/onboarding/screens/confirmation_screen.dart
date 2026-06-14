import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../domain/entities/stage.dart';
import '../../common/date_helpers.dart';
import '../../theme/app_colors.dart';
import '../onboarding_state.dart';

class ConfirmationScreen extends ConsumerStatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  ConsumerState<ConfirmationScreen> createState() =>
      _ConfirmationScreenState();
}

class _ConfirmationScreenState extends ConsumerState<ConfirmationScreen> {
  Stage? _stage;

  @override
  void initState() {
    super.initState();
    _loadStage();
  }

  Future<void> _loadStage() async {
    final stageId = ref.read(onboardingProvider).stageId;
    if (stageId == null) return;
    final stages = await ref.read(referenceRepositoryProvider).getStages();
    if (!mounted) return;
    setState(() {
      _stage = stages.firstWhere((s) => s.id == stageId);
    });
  }

  String _formatBirthDate(DateTime date) {
    return '${date.day} ${frenchMonths[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Tout est prêt, ${state.parentName}',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 40),
        _SummaryRow(label: 'Bébé', value: state.babyName),
        _SummaryRow(
          label: 'Né le',
          value: state.birthDate != null
              ? _formatBirthDate(state.birthDate!)
              : '—',
        ),
        _SummaryRow(
          label: 'Terme',
          value: '${state.gestationalWeeks} semaines',
        ),
        _SummaryRow(
          label: 'Situation',
          value: _stage?.label ?? '—',
          showDivider: false,
        ),
        const SizedBox(height: 32),
        Text(
          'Tu n’es pas seul·e dans ce parcours',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}
