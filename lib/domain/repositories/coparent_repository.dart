import '../entities/coparent_profile.dart';
import '../entities/shared_emotion.dart';

/// Résultat d'une tentative d'appairage via QR.
enum CoparentLinkResult {
  success,
  invalidCode,
  alreadyPaired,
  selfPair,
  notReady,
  error,
}

/// Accès au partage co-parent (backend distant). Toutes les méthodes dégradent
/// proprement quand le backend n'est pas configuré/disponible ([isAvailable]).
abstract class CoparentRepository {
  /// Backend configuré et session (anonyme) ouverte.
  bool get isAvailable;

  /// Identifiant de l'utilisateur courant (= propriétaire des saisies partagées).
  String? get currentUserId;

  /// Crée/met à jour le profil distant (prénom) de l'utilisateur courant.
  Future<void> ensureProfile(String firstName);

  /// Charge à encoder dans le QR : `"<uid>:<pairing_code>"`.
  Future<String?> myPairingPayload();

  /// Appaire avec le profil décrit par [scannedPayload] (issu d'un QR scanné).
  Future<CoparentLinkResult> linkWith(String scannedPayload);

  /// Rompt l'appairage des deux côtés (le co-parent perd l'accès via le RLS).
  Future<void> unlink();

  /// Supprime du serveur toutes les données partagées de l'utilisateur
  /// (rompt l'appairage puis efface ses saisies partagées).
  Future<void> deleteMyData();

  /// Id du co-parent appairé (ou null), en temps réel sur le profil courant.
  Stream<String?> watchCoparentId();

  /// Profil (prénom) d'un utilisateur appairé.
  Future<CoparentProfile?> getProfile(String id);

  /// Saisies partagées d'un propriétaire (le co-parent), en temps réel.
  Stream<List<SharedEmotion>> watchSharedEntries(String ownerId);

  /// Pousse (upsert idempotent) les saisies locales vers le backend.
  Future<void> pushEntries(List<SharedEntryUpload> entries);
}
