// Helpers de dates partagés par l'historique, le détail et les paramètres.

/// Mois en français (minuscules). Pour une version en capitales (en-têtes),
/// utiliser `frenchMonths[i].toUpperCase()`.
const frenchMonths = <String>[
  'janvier',
  'février',
  'mars',
  'avril',
  'mai',
  'juin',
  'juillet',
  'août',
  'septembre',
  'octobre',
  'novembre',
  'décembre',
];

/// Jours de la semaine en français, indexés par `DateTime.weekday - 1`
/// (lundi = 1).
const frenchWeekdays = <String>[
  'Lundi',
  'Mardi',
  'Mercredi',
  'Jeudi',
  'Vendredi',
  'Samedi',
  'Dimanche',
];

/// Date tronquée à minuit, pratique pour comparer ou regrouper par jour.
DateTime normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);
