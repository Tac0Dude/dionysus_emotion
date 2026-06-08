import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import 'lock_controller.dart';
import 'widgets/pin_pad.dart';

/// Écran de déverrouillage présenté au lancement (et au retour de
/// l'arrière-plan) lorsque le verrouillage est actif.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  bool _promptedBiometric = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybePromptBiometric());
  }

  Future<void> _maybePromptBiometric() async {
    if (_promptedBiometric) return;
    final lock = ref.read(lockControllerProvider);
    if (!lock.biometricEnabled) return;
    _promptedBiometric = true;
    await _authenticateBiometric();
  }

  Future<void> _authenticateBiometric() async {
    final controller = ref.read(lockControllerProvider.notifier);
    final ok = await controller.authenticateBiometric();
    if (ok) controller.unlock();
  }

  Future<bool> _verifyPin(String pin) async {
    final controller = ref.read(lockControllerProvider.notifier);
    final ok = await controller.verifyPin(pin);
    if (ok) controller.unlock();
    return ok;
  }

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(lockControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const Icon(
                Icons.lock_outline,
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'Dionysus est verrouillé',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Saisis ton code pour continuer',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const Spacer(),
              PinPad(
                onCompleted: _verifyPin,
                leftAction: lock.biometricEnabled
                    ? IconButton(
                        onPressed: _authenticateBiometric,
                        icon: const Icon(
                          Icons.fingerprint,
                          size: 34,
                          color: AppColors.primary,
                        ),
                        tooltip: 'Déverrouiller par biométrie',
                      )
                    : null,
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
