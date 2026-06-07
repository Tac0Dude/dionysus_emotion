import 'package:flutter/material.dart';

import '../../../domain/entities/emotion.dart';
import '../../../domain/entities/quadrant.dart';
import '../../shell/bottom_nav.dart';
import '../../theme/app_colors.dart';
import '../quadrant_visuals.dart';
import '../widgets/intensity_picker.dart';
import 'trigger_screen.dart';

class IntensityScreen extends StatefulWidget {
  final Quadrant quadrant;
  final Emotion emotion;

  const IntensityScreen({
    super.key,
    required this.quadrant,
    required this.emotion,
  });

  @override
  State<IntensityScreen> createState() => _IntensityScreenState();
}

class _IntensityScreenState extends State<IntensityScreen> {
  int? _intensity;

  void _openTriggerScreen() {
    if (_intensity == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TriggerScreen(
          quadrant: widget.quadrant,
          emotion: widget.emotion,
          intensity: _intensity!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visual = visualFor(widget.quadrant.label);
    final textTheme = Theme.of(context).textTheme;
    final canContinue = _intensity != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text(
          widget.emotion.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNav(currentTab: MainTab.entry),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            children: [
              Text(
                'A quelle\nintensité?',
                textAlign: TextAlign.center,
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 56),
              IntensityPicker(
                value: _intensity,
                onChanged: (v) => setState(() => _intensity = v),
                accent: visual.color,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canContinue ? _openTriggerScreen : null,
                  child: const Text('Continuer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
