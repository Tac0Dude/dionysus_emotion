/// Projeté d'une saisie émotionnelle tel que partagé avec le co-parent.
///
/// Volontairement minimal : ni activité, ni lieu, ni phrase de validation — le
/// co-parent ne voit que de quoi peindre le bocal et afficher la dernière émotion.
class SharedEmotion {
  final String emotionName;
  final String quadrantLabel;
  final int intensity;
  final DateTime createdAt;

  const SharedEmotion({
    required this.emotionName,
    required this.quadrantLabel,
    required this.intensity,
    required this.createdAt,
  });
}

/// Donnée envoyée vers le backend pour une saisie locale. Inclut l'id local
/// (`clientEntryId`) qui rend la synchronisation idempotente (upsert).
class SharedEntryUpload {
  final int clientEntryId;
  final String emotionName;
  final String quadrantLabel;
  final int intensity;
  final DateTime createdAt;

  const SharedEntryUpload({
    required this.clientEntryId,
    required this.emotionName,
    required this.quadrantLabel,
    required this.intensity,
    required this.createdAt,
  });
}
