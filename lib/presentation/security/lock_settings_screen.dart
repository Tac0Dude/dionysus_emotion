import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import 'lock_controller.dart';
import 'pin_setup_screen.dart';

/// Écran de configuration du verrouillage : activer/désactiver le code PIN et
/// le déverrouillage biométrique.
class LockSettingsScreen extends ConsumerWidget {
  const LockSettingsScreen({super.key});

  Future<void> _setupPin(BuildContext context) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const PinSetupScreen()),
    );
  }

  Future<void> _disableLock(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Désactiver le verrouillage ?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Ton suivi ne sera plus protégé par un code ou la biométrie.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Désactiver',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(lockControllerProvider.notifier).disableLock();
    }
  }

  Future<void> _toggleBiometric(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    final controller = ref.read(lockControllerProvider.notifier);
    if (!enabled) {
      await controller.setBiometricEnabled(false);
      return;
    }
    // On confirme que la biométrie fonctionne avant de l'activer.
    final ok = await controller.authenticateBiometric();
    if (ok) {
      await controller.setBiometricEnabled(true);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentification biométrique non confirmée.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lock = ref.watch(lockControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Verrouillage',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          children: [
            const Text(
              'Protège ton suivi émotionnel par un code PIN, avec un '
              'déverrouillage biométrique optionnel.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            if (!lock.isPinSet)
              _LockTile(
                icon: Icons.lock_outline,
                title: 'Activer le verrouillage',
                subtitle: 'Définir un code à 4 chiffres',
                onTap: () => _setupPin(context),
              )
            else ...[
              _LockTile(
                icon: Icons.password_outlined,
                title: 'Modifier le code PIN',
                subtitle: 'Changer ton code à 4 chiffres',
                onTap: () => _setupPin(context),
              ),
              const SizedBox(height: 12),
              _BiometricTile(
                available: lock.biometricAvailable,
                enabled: lock.biometricEnabled,
                onChanged: (v) => _toggleBiometric(context, ref, v),
              ),
              const SizedBox(height: 12),
              _LockTile(
                icon: Icons.lock_open_outlined,
                title: 'Désactiver le verrouillage',
                subtitle: 'Supprimer le code et la biométrie',
                danger: true,
                onTap: () => _disableLock(context, ref),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LockTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool danger;

  const _LockTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? Colors.redAccent : AppColors.textPrimary;
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
              children: [
                Icon(icon, size: 26, color: color),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
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

class _BiometricTile extends StatelessWidget {
  final bool available;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _BiometricTile({
    required this.available,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.fingerprint, size: 26, color: AppColors.textPrimary),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Déverrouillage biométrique',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  available
                      ? 'Empreinte ou reconnaissance faciale'
                      : 'Indisponible sur cet appareil',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled && available,
            onChanged: available ? onChanged : null,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
