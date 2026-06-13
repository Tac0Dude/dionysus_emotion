const Map<String, String> _emotionArticles = {
  'Joie': 'de la',
  'Fierté': 'de la',
  'Admiration': 'de l\'',
  'Intérêt': 'de l\'',
  'Amusement': 'de l\'',
  'Plaisir': 'du',
  'Contentement': 'du',
  'Amour': 'de l\'',
  'Soulagement': 'du',
  'Compassion': 'de la',
  'Colère': 'de la',
  'Mépris': 'du',
  'Haine': 'de la',
  'Dégoût': 'du',
  'Honte': 'de la',
  'Tristesse': 'de la',
  'Culpabilité': 'de la',
  'Regret': 'du',
  'Déception': 'de la',
  'Peur': 'de la',
};

String articleFor(String emotionName) =>
    _emotionArticles[emotionName] ?? 'de la';

String emotionNameForDisplay(String emotionName) => emotionName.toLowerCase();

/// Vrai si l'émotion s'élide ("l'amour", "d'intérêt") plutôt que de prendre un
/// déterminant plein ("la joie", "du plaisir"). Dérivé de l'article défini :
/// les seules émotions à voyelle initiale (Amour, Admiration, Amusement,
/// Intérêt) sont aussi celles qui portent « de l' », et « Honte » (h aspiré)
/// garde « de la » — l'élision suit donc exactement la table des articles.
bool elidesArticle(String emotionName) => articleFor(emotionName) == "de l'";

/// Forme partitive après une quantité ("beaucoup", "un peu") : "de joie",
/// "de plaisir", "d'amour", "d'intérêt".
String partitiveDe(String emotionName) {
  final lower = emotionNameForDisplay(emotionName);
  return elidesArticle(emotionName) ? "d'$lower" : 'de $lower';
}
