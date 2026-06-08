import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/security/lock_service.dart';

final lockServiceProvider = Provider<LockService>((ref) => LockService());

class LockState {
  /// Chargement initial de la configuration depuis le stockage sécurisé.
  final bool loading;

  /// Un code PIN est défini : le verrouillage est actif.
  final bool isPinSet;

  /// Déverrouillage biométrique activé par l'utilisateur.
  final bool biometricEnabled;

  /// L'appareil supporte la biométrie (empreinte/visage enregistré).
  final bool biometricAvailable;

  /// Session déverrouillée pour la durée d'utilisation courante.
  final bool isUnlocked;

  const LockState({
    this.loading = true,
    this.isPinSet = false,
    this.biometricEnabled = false,
    this.biometricAvailable = false,
    this.isUnlocked = false,
  });

  /// Faut-il présenter l'écran de déverrouillage ?
  bool get isLocked => isPinSet && !isUnlocked;

  LockState copyWith({
    bool? loading,
    bool? isPinSet,
    bool? biometricEnabled,
    bool? biometricAvailable,
    bool? isUnlocked,
  }) {
    return LockState(
      loading: loading ?? this.loading,
      isPinSet: isPinSet ?? this.isPinSet,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}

class LockController extends StateNotifier<LockState> {
  final LockService _service;

  LockController(this._service) : super(const LockState()) {
    _load();
  }

  Future<void> _load() async {
    final isPinSet = await _service.isPinSet();
    final biometricAvailable = await _service.canUseBiometrics();
    final biometricEnabled =
        biometricAvailable && await _service.isBiometricEnabled();
    state = state.copyWith(
      loading: false,
      isPinSet: isPinSet,
      biometricEnabled: biometricEnabled,
      biometricAvailable: biometricAvailable,
      // Sans PIN défini, l'app est ouverte. Avec PIN, on démarre verrouillé.
      isUnlocked: !isPinSet,
    );
  }

  /// Définit (ou modifie) le code PIN et active le verrouillage.
  Future<void> setPin(String pin) async {
    await _service.setPin(pin);
    state = state.copyWith(isPinSet: true, isUnlocked: true);
  }

  /// Désactive complètement le verrouillage.
  Future<void> disableLock() async {
    await _service.clearLock();
    state = state.copyWith(
      isPinSet: false,
      biometricEnabled: false,
      isUnlocked: true,
    );
  }

  Future<bool> verifyPin(String pin) => _service.verifyPin(pin);

  Future<void> setBiometricEnabled(bool enabled) async {
    await _service.setBiometricEnabled(enabled);
    state = state.copyWith(biometricEnabled: enabled);
  }

  Future<bool> authenticateBiometric() => _service.authenticateBiometric();

  /// Déverrouille la session courante (après PIN ou biométrie validés).
  void unlock() => state = state.copyWith(isUnlocked: true);

  /// Re-verrouille (passage en arrière-plan).
  void lock() {
    if (state.isPinSet) {
      state = state.copyWith(isUnlocked: false);
    }
  }
}

final lockControllerProvider =
    StateNotifierProvider<LockController, LockState>(
  (ref) => LockController(ref.watch(lockServiceProvider)),
);
