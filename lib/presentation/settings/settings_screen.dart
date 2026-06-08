import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/entities/parent.dart';
import '../../domain/entities/stage.dart';
import '../onboarding/onboarding_state.dart';
import '../onboarding/widgets/cream_text_field.dart';
import '../security/lock_controller.dart';
import '../security/lock_settings_screen.dart';
import '../shell/bottom_nav.dart';
import '../theme/app_colors.dart';

const _monthsLong = [
  'janvier',
  'février',
  'mars',
  'avril',
  'mai',
  'juin',
  'juillet',
  'août',
  'septembre',
  'octobre',
  'novembre',
  'décembre',
];

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  List<Stage> _stages = const [];

  @override
  void initState() {
    super.initState();
    _loadStages();
  }

  Future<void> _loadStages() async {
    final stages = await ref.read(referenceRepositoryProvider).getStages();
    if (!mounted) return;
    setState(() => _stages = stages);
  }

  String _formatBirthDate(DateTime d) =>
      '${d.day} ${_monthsLong[d.month - 1]} ${d.year}';

  Stage? _stageById(int id) {
    if (_stages.isEmpty) return null;
    return _stages.firstWhere(
      (s) => s.id == id,
      orElse: () => _stages.first,
    );
  }

  void _comingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cette fonctionnalité arrivera bientôt.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _editFirstName(Parent parent) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => _FirstNameDialog(initial: parent.firstName),
    );
    final trimmed = newName?.trim();
    if (trimmed == null || trimmed.isEmpty || trimmed == parent.firstName) {
      return;
    }
    await ref.read(parentRepositoryProvider).updateFirstName(
          parentId: parent.id,
          firstName: trimmed,
        );
  }

  Future<void> _editBaby(Parent parent) async {
    final result = await showModalBottomSheet<_BabyEditResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _BabyEditSheet(parent: parent),
    );
    if (result == null) return;
    final unchanged = result.babyFirstName == parent.babyFirstName &&
        result.babyBirthDate == parent.babyBirthDate &&
        result.gestationalAgeWeeks == parent.gestationalAgeWeeks;
    if (unchanged) return;
    await ref.read(parentRepositoryProvider).updateBaby(
          parentId: parent.id,
          babyFirstName: result.babyFirstName,
          babyBirthDate: result.babyBirthDate,
          gestationalAgeWeeks: result.gestationalAgeWeeks,
        );
  }

  Future<void> _pickStage(Parent parent) async {
    if (_stages.isEmpty) return;
    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phase actuelle',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tu peux la mettre à jour à mesure que ton parcours évolue.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                for (final stage in _stages)
                  _StageOption(
                    label: stage.label,
                    selected: stage.id == parent.stageId,
                    onTap: () => Navigator.of(context).pop(stage.id),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (selected != null && selected != parent.stageId) {
      await ref.read(parentRepositoryProvider).updateStage(
            parentId: parent.id,
            stageId: selected,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final parentAsync = ref.watch(currentParentProvider);
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentTab: MainTab.settings),
      body: SafeArea(
        bottom: false,
        child: parentAsync.when(
          data: (parent) {
            if (parent == null) {
              return const Center(
                child: Text(
                  'Profil introuvable.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }
            return _buildContent(parent);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => Center(child: Text('Erreur : $e')),
        ),
      ),
    );
  }

  Widget _buildContent(Parent parent) {
    final stage = _stageById(parent.stageId);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paramètres',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 14),
          const _SectionTitle('Widget'),
          _SettingsCard(
            icon: Icons.phone_android_outlined,
            title: 'Installer le widget',
            onTap: _comingSoon,
          ),
          const SizedBox(height: 22),
          const _SectionTitle('Mon profil'),
          _SettingsCard(
            icon: Icons.person_outline,
            title: 'Prénom',
            subtitle: parent.firstName,
            onTap: () => _editFirstName(parent),
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            icon: Icons.favorite_outline,
            title: 'Mon bébé',
            subtitle:
                '${parent.babyFirstName} · né le ${_formatBirthDate(parent.babyBirthDate)}',
            onTap: () => _editBaby(parent),
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            icon: Icons.calendar_month_outlined,
            title: 'Phase actuelle',
            subtitle: stage?.label ?? '—',
            onTap: () => _pickStage(parent),
          ),
          const SizedBox(height: 22),
          const _SectionTitle('Co-parent'),
          _SettingsCard(
            icon: Icons.group_add_outlined,
            title: 'Ajouter un co-parent',
            subtitle: 'Partager son suivi émotionnel',
            onTap: _comingSoon,
          ),
          const SizedBox(height: 22),
          const _SectionTitle('Confidentialité'),
          Consumer(
            builder: (context, ref, _) {
              final lock = ref.watch(lockControllerProvider);
              final subtitle = !lock.isPinSet
                  ? 'Désactivé'
                  : lock.biometricEnabled
                      ? 'Code PIN · biométrie'
                      : 'Code PIN';
              return _SettingsCard(
                icon: Icons.lock_outline,
                title: 'Verrouillage',
                subtitle: subtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LockSettingsScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsCard({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cream,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 72),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 26, color: AppColors.textPrimary),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FirstNameDialog extends StatefulWidget {
  final String initial;

  const _FirstNameDialog({required this.initial});

  @override
  State<_FirstNameDialog> createState() => _FirstNameDialogState();
}

class _FirstNameDialogState extends State<_FirstNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: Text(
        'Ton prénom',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
      ),
      content: CreamTextField(
        controller: _controller,
        label: 'Prénom',
        autofocus: true,
        textInputAction: TextInputAction.done,
        onChanged: (_) => setState(() {}),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Annuler',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: _controller.text.trim().isEmpty ? null : _submit,
          child: const Text(
            'Enregistrer',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _BabyEditResult {
  final String babyFirstName;
  final DateTime babyBirthDate;
  final int gestationalAgeWeeks;

  const _BabyEditResult({
    required this.babyFirstName,
    required this.babyBirthDate,
    required this.gestationalAgeWeeks,
  });
}

class _BabyEditSheet extends StatefulWidget {
  final Parent parent;

  const _BabyEditSheet({required this.parent});

  @override
  State<_BabyEditSheet> createState() => _BabyEditSheetState();
}

class _BabyEditSheetState extends State<_BabyEditSheet> {
  late final TextEditingController _nameController;
  late DateTime _birthDate;
  late int _weeks;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.parent.babyFirstName);
    _birthDate = widget.parent.babyBirthDate;
    _weeks = widget.parent.gestationalAgeWeeks;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      helpText: 'Date de naissance',
      cancelText: 'Annuler',
      confirmText: 'OK',
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    return '$dd/$mm/${date.year}';
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(
      _BabyEditResult(
        babyFirstName: name,
        babyBirthDate: _birthDate,
        gestationalAgeWeeks: _weeks,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mon bébé',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              CreamTextField(
                controller: _nameController,
                label: 'Prénom du bébé',
                textInputAction: TextInputAction.done,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 24),
              const Text(
                'Date de naissance',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickDate,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary, width: 1.4),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.textPrimary,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(_birthDate),
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Terme (semaines)',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text(
                    '${OnboardingState.minWeeks}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _weeks.toDouble(),
                      min: OnboardingState.minWeeks.toDouble(),
                      max: OnboardingState.maxWeeks.toDouble(),
                      divisions:
                          OnboardingState.maxWeeks - OnboardingState.minWeeks,
                      label: '$_weeks sem',
                      onChanged: (v) => setState(() => _weeks = v.round()),
                    ),
                  ),
                  const Text(
                    '${OnboardingState.maxWeeks}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Center(
                child: Text(
                  '$_weeks sem',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      _nameController.text.trim().isEmpty ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Enregistrer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? AppColors.cream : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.divider,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
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
      ),
    );
  }
}
