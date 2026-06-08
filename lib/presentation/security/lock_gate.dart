import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import 'lock_controller.dart';
import 'lock_screen.dart';

/// Intercale l'écran de déverrouillage devant [child] quand le verrouillage
/// est actif, et re-verrouille l'app lorsqu'elle passe en arrière-plan.
class LockGate extends ConsumerStatefulWidget {
  final Widget child;

  const LockGate({super.key, required this.child});

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      ref.read(lockControllerProvider.notifier).lock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(lockControllerProvider);

    if (lock.loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Stack(
      children: [
        widget.child,
        if (lock.isLocked)
          const Positioned.fill(child: LockScreen()),
      ],
    );
  }
}
