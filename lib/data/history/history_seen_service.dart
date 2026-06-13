import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Mémorise la date à laquelle l'historique a été consulté pour la dernière
/// fois, afin de pouvoir mettre en évidence les saisies ajoutées depuis.
///
/// Stockée dans le stockage chiffré déjà utilisé par l'app (pas de dépendance
/// supplémentaire) ; la donnée n'est pas sensible mais le mécanisme est partagé.
class HistorySeenService {
  static const _key = 'history_last_seen_at';

  static const _storageOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  final FlutterSecureStorage _storage;

  HistorySeenService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Dernière consultation, ou null si l'historique n'a encore jamais été vu.
  Future<DateTime?> lastSeenAt() async {
    final value = await _storage.read(key: _key, aOptions: _storageOptions);
    final ms = value == null ? null : int.tryParse(value);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  /// Enregistre [at] (ou maintenant) comme date de dernière consultation.
  Future<void> markSeen([DateTime? at]) async {
    final moment = at ?? DateTime.now();
    await _storage.write(
      key: _key,
      value: moment.millisecondsSinceEpoch.toString(),
      aOptions: _storageOptions,
    );
  }
}
