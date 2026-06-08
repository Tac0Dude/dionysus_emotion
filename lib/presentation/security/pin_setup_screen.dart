import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import 'lock_controller.dart';
import 'widgets/pin_pad.dart';

/// Création ou modification du code PIN : saisie puis confirmation.
/// Renvoie `true` via [Navigator.pop] si un nouveau code a été enregistré.
class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  String? _firstEntry;
  bool _mismatch = false;

  bool get _confirming => _firstEntry != null;

  Future<bool> _onCompleted(String pin) async {
    if (!_confirming) {
      setState(() {
        _firstEntry = pin;
        _mismatch = false;
      });
      return true;
    }

    if (pin != _firstEntry) {
      setState(() {
        _firstEntry = null;
        _mismatch = true;
      });
      return false;
    }

    await ref.read(lockControllerProvider.notifier).setPin(pin);
    if (mounted) Navigator.of(context).pop(true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final title = _confirming ? 'Confirme ton code' : 'Choisis un code';
    final subtitle = _mismatch
        ? 'Les codes ne correspondent pas, réessaie'
        : 'Un code à 4 chiffres protégera ton suivi';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: _mismatch ? Colors.redAccent : AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              PinPad(
                // Clé liée à la phase pour réinitialiser proprement le pavé.
                key: ValueKey(_confirming),
                onCompleted: _onCompleted,
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
