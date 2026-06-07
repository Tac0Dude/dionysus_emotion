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
