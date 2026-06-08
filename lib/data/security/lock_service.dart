import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Gère le verrouillage de l'application : code PIN (haché et salé, stocké dans
/// le stockage sécurisé du système) et authentification biométrique optionnelle.
class LockService {
  static const _kPinHash = 'lock_pin_hash';
  static const _kPinSalt = 'lock_pin_salt';
  static const _kBiometric = 'lock_biometric_enabled';

  static const _storageOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  final FlutterSecureStorage _storage;
  final LocalAuthentication _auth;

  LockService({
    FlutterSecureStorage? storage,
    LocalAuthentication? auth,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _auth = auth ?? LocalAuthentication();

  // --- PIN -----------------------------------------------------------------

  Future<bool> isPinSet() async {
    final hash = await _storage.read(key: _kPinHash, aOptions: _storageOptions);
    return hash != null && hash.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    final salt = _generateSalt();
    await _storage.write(
      key: _kPinSalt,
      value: salt,
      aOptions: _storageOptions,
    );
    await _storage.write(
      key: _kPinHash,
      value: _hashPin(pin, salt),
      aOptions: _storageOptions,
    );
  }

  Future<bool> verifyPin(String pin) async {
    final salt = await _storage.read(key: _kPinSalt, aOptions: _storageOptions);
    final hash = await _storage.read(key: _kPinHash, aOptions: _storageOptions);
    if (salt == null || hash == null) return false;
    return _hashPin(pin, salt) == hash;
  }

  /// Désactive complètement le verrouillage (supprime PIN et biométrie).
  Future<void> clearLock() async {
    await _storage.delete(key: _kPinHash, aOptions: _storageOptions);
    await _storage.delete(key: _kPinSalt, aOptions: _storageOptions);
    await _storage.delete(key: _kBiometric, aOptions: _storageOptions);
  }

  // --- Biométrie -----------------------------------------------------------

  Future<bool> isBiometricEnabled() async {
    final value =
        await _storage.read(key: _kBiometric, aOptions: _storageOptions);
    return value == 'true';
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: _kBiometric,
      value: enabled.toString(),
      aOptions: _storageOptions,
    );
  }

  /// L'appareil supporte la biométrie et au moins une empreinte/visage est
  /// enregistré.
  Future<bool> canUseBiometrics() async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return false;
      final canCheck = await _auth.canCheckBiometrics;
      if (!canCheck) return false;
      final available = await _auth.getAvailableBiometrics();
      return available.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticateBiometric() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Déverrouille Dionysus',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  // --- Helpers -------------------------------------------------------------

  String _generateSalt() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    return base64UrlEncode(bytes);
  }

  String _hashPin(String pin, String salt) {
    return sha256.convert(utf8.encode('$salt:$pin')).toString();
  }
}
