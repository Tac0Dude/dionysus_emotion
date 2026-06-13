 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../domain/entities/quadrant.dart';
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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(referenceRepositoryProvider);
    final list = await repo.getQuadrants();
    if (!mounted) return;
    setState(() {
      _quadrants = list;
      _loading = false;
    });
  }

  Quadrant _quadrantByLabel(String label) =>
      _quadrants.firstWhere((q) => q.label == label);

  bool _hasLabel(String label) =>
      _quadrants.any((q) => q.label == label);

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
}
