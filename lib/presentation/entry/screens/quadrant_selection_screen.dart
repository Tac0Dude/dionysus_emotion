 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../domain/entities/parent.dart';
import '../../../domain/entities/quadrant.dart';
import '../../../domain/entities/stage.dart';
import '../../common/stage_picker.dart';
import '../../shell/bottom_nav.dart';
import '../../theme/app_colors.dart';
import '../quadrant_visuals.dart';
import '../widgets/animated_quadrant_tile.dart';
import 'emotion_selection_screen.dart';

class QuadrantSelectionScreen extends ConsumerStatefulWidget {
  const QuadrantSelectionScreen({super.key});

  @override
  ConsumerState<QuadrantSelectionScreen> createState() =>
      _QuadrantSelectionScreenState();
}

class _QuadrantSelectionScreenState
    extends ConsumerState<QuadrantSelectionScreen> {
  List<Quadrant> _quadrants = const [];
  List<Stage> _stages = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(referenceRepositoryProvider);
    final quadrants = await repo.getQuadrants();
    final stages = await repo.getStages();
    if (!mounted) return;
    setState(() {
      _quadrants = quadrants;
      _stages = stages;
      _loading = false;
    });
  }

  Quadrant _quadrantByLabel(String label) =>
      _quadrants.firstWhere((q) => q.label == label);

  bool _hasLabel(String label) =>
      _quadrants.any((q) => q.label == label);

  Stage? _stageById(int id) {
    if (_stages.isEmpty) return null;
    return _stages.firstWhere(
      (s) => s.id == id,
      orElse: () => _stages.first,
    );
  }

  Future<void> _pickStage(Parent parent) async {
    if (_stages.isEmpty) return;
    final selected = await showStagePicker(
      context: context,
      stages: _stages,
      currentStageId: parent.stageId,
    );
    if (selected != null && selected != parent.stageId) {
      await ref.read(parentRepositoryProvider).updateStage(
            parentId: parent.id,
            stageId: selected,
          );
    }
  }

  void _openEmotionScreen(Quadrant quadrant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EmotionSelectionScreen(quadrant: quadrant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      bottomNavigationBar: const BottomNav(currentTab: MainTab.entry),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : Column(
                  children: [
                    Text(
                      'Comment te\nsens-tu en ce\nmoment?',
                      textAlign: TextAlign.center,
                      style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Expanded(child: _buildGrid()),
                    const SizedBox(height: 12),
                    _buildStageButton(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    const layout = <List<String>>[
      [
        'Difficile mais en contrôle',
        'Agréable et en contrôle',
      ],
      [
        'Difficile et dépassé·e',
        'Agréable mais dépassé·e',
      ],
    ];

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var r = 0; r < layout.length; r++) ...[
            Row(
              children: [
                for (var c = 0; c < layout[r].length; c++) ...[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: _hasLabel(layout[r][c])
                          ? AnimatedQuadrantTile(
                              visual: visualFor(layout[r][c]),
                              // Phase décalée par tuile pour désynchroniser.
                              phase: (r * 2 + c) / 4,
                              onTap: () => _openEmotionScreen(
                                _quadrantByLabel(layout[r][c]),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStageButton() {
    final parent = ref.watch(currentParentProvider).asData?.value;
    if (parent == null || _stages.isEmpty) return const SizedBox.shrink();
    final stage = _stageById(parent.stageId);
    return Material(
      color: AppColors.cream,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => _pickStage(parent),
        borderRadius: BorderRadius.circular(14),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'Phase : ${stage?.label ?? '—'}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.expand_more,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
