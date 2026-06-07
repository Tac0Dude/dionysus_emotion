import 'app_database.dart';

class _QuadrantSeed {
  final String label;
  final List<String> emotions;
  const _QuadrantSeed(this.label, this.emotions);
}

const _quadrantSeeds = <_QuadrantSeed>[
  _QuadrantSeed(
    'Agréable et en contrôle',
    ['Joie', 'Fierté', 'Admiration', 'Intérêt', 'Amusement'],
  ),
  _QuadrantSeed(
    'Agréable mais dépassé·e',
    ['Plaisir', 'Contentement', 'Amour', 'Soulagement', 'Compassion'],
  ),
  _QuadrantSeed(
    'Difficile mais en contrôle',
    ['Colère', 'Mépris', 'Haine', 'Dégoût', 'Honte'],
  ),
  _QuadrantSeed(
    'Difficile et dépassé·e',
    ['Tristesse', 'Culpabilité', 'Regret', 'Déception', 'Peur'],
  ),
];

const _stages = <({String code, String label})>[
  (code: 'admission', label: 'Admission'),
  (code: 'hospitalization', label: 'Hospitalisation'),
  (code: 'intermediate', label: 'Soins intermédiaires'),
  (code: 'home', label: 'Retour à la maison'),
];

const _activities = <String>[
  'Soins kangourous',
  'Visite médicale',
  'Résultats d\'examen',
  'Visite',
  'Séparation du soir',
  'Appel',
  'Moment de soin',
  'Promenade',
  'Autre',
];

const _locations = <String>[
  'Auprès de mon enfant',
  'Dans la salle d\'attente',
  'A la maison',
  'Dans les couloirs de l\'hôpital',
  'En dehors de l\'hôpital',
  'Autre',
];

Future<void> seedReferenceData(AppDatabase db) async {
  await _seedQuadrantsAndEmotions(db);
  await _seedStages(db);
  await seedActivitiesAndLocations(db);
}

Future<void> _seedQuadrantsAndEmotions(AppDatabase db) async {
  for (final quadrant in _quadrantSeeds) {
    final quadrantId = await db.into(db.quadrants).insert(
          QuadrantsCompanion.insert(label: quadrant.label),
        );
    await db.batch((b) {
      b.insertAll(
        db.emotions,
        quadrant.emotions
            .map((name) => EmotionsCompanion.insert(
                  name: name,
                  quadrantId: quadrantId,
                ))
            .toList(),
      );
    });
  }
}

Future<void> _seedStages(AppDatabase db) async {
  await db.batch((b) {
    b.insertAll(
      db.stages,
      _stages
          .map((s) => StagesCompanion.insert(code: s.code, label: s.label))
          .toList(),
    );
  });
}

Future<void> seedActivitiesAndLocations(AppDatabase db) async {
  await db.batch((b) {
    b.insertAll(
      db.activities,
      _activities.map((label) => ActivitiesCompanion.insert(label: label)).toList(),
    );
    b.insertAll(
      db.locations,
      _locations.map((label) => LocationsCompanion.insert(label: label)).toList(),
    );
  });
}
