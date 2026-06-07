# Dionysus — Application de monitoring émotionnel

## Contexte
Application Flutter destinée aux parents de prématurés hospitalisés en NICU.

## Maquettes
Les maquettes de référence sont disponibles dans le dossier `docs/screens/`.
Consulte-les pour comprendre le design attendu de chaque écran avant de coder.

- `01_onboarding_welcome.png` — Écran de bienvenue
- `02_onboarding_name.png` — Saisie prénom parent
- `03_onboarding_baby.png` — Saisie prénom bébé
- `04_onboarding_date_term.png` — Date naissance et terme
- `05_onboarding_confirmation.png` — Confirmation onboarding
- `06_entry_quadrant.png` — Sélection quadrant GEW
- `07_entry_emotion.png` — Sélection émotion
- `08_entry_intensity.png` — Sélection intensité
- `09_entry_trigger.png` — Déclencheur optionnel
- `10_entry_validation_positive.png` — Message validation émotion positive
- `11_entry_validation_negative.png` — Message validation émotion négative avec ressources
- `12_history_jar.png` — Historique avec bocal
- `13_history_day_detail.png` — Détail d'un jour
- `14_history_entry_detail.png` — Détail d'une saisie
- `15_settings.png` — Paramètres
- `16_widget_idle.png` — Widget au repos
- `17_widget_step1_quadrant.png` — Widget étape 1
- `18_widget_step2_emotion.png` — Widget étape 2
- `19_widget_step3_intensity.png` — Widget étape 3
- `20_widget_confirmation.png` — Widget confirmation

## Stack technique
- Flutter (latest stable)
- SQLite via drift
- Riverpod pour le state management
- Material 3
- Police Nunito (Google Fonts)

## Architecture
Clean Architecture avec Repository pattern
- presentation/ — widgets et écrans
- domain/ — entités et use cases
- data/ — repositories SQLite et models

## Modèle de données
Table parent {
id integer [pk, increment]
first_name text [not null]
baby_first_name text [not null]
baby_birth_date date [not null]
gestational_age_weeks integer [not null]
stage_id integer [ref: > stage.id, not null]
coparent_id integer [ref: > parent.id, null]
sharing_consent boolean [not null, default: false]
created_at datetime [not null]
}

Table stage {
id integer [pk, increment]
code text [not null, unique]
label text [not null]
}

Table entry {
id integer [pk, increment]
parent_id integer [ref: > parent.id, not null]
emotion_id integer [ref: > emotion.id, not null]
intensity integer [not null, note: '1 to 5']
activity_id integer [ref: > activity.id, null]
location_id integer [ref: > location.id, null]
created_at datetime [not null]
}

Table emotion {
id integer [pk, increment]
name text [not null]
quadrant_id integer [ref: > quadrant.id, not null]
}

Table quadrant {
id integer [pk, increment]
label text [not null]
}

Table activity {
id integer [pk, increment]
label text [not null]
}

Table location {
id integer [pk, increment]
label text [not null]
}

## Design system
- Fond : #FAF7F2
- Navbar : #EDE8DC
- Quadrant agréable/contrôle : #C8E6D0 — cercle
- Quadrant agréable/dépassé : #F5DDD0 — forme organique
- Quadrant difficile/contrôle : #DDD4ED — carré arrondi
- Quadrant difficile/dépassé : #C8D8E8 — rectangle arrondi

## Modèle GEW — émotions par quadrant
Agréable et en contrôle : Joie, Fierté, Admiration, Intérêt, Amusement
Agréable mais dépassé·e : Plaisir, Contentement, Amour, Soulagement, Compassion
Difficile mais en contrôle : Colère, Mépris, Haine, Dégoût, Honte
Difficile et dépassé·e : Tristesse, Culpabilité, Regret, Déception, Peur

## Écrans à implémenter
1. Onboarding (5 écrans)
2. Sélection quadrant
3. Sélection émotion
4. Sélection intensité
5. Déclencheur optionnel
6. Message de validation
7. Historique avec bocal
8. Détail saisie unique
9. Détail jour
10. Paramètres
11. Widget Android

## Messages de validation bienveillants
Les messages de validation affichés après chaque saisie émotionnelle sont stockés dans `docs/sentences.txt`.
Le fichier contient 3 phrases par émotion GEW (60 phrases au total).
Format : une émotion par bloc, 3 phrases numérotées en dessous.
L'app sélectionne une phrase aléatoirement parmi les 3 disponibles pour l'émotion enregistrée.

## Émotions GEW par quadrant

### Agréable et en contrôle (cercle — #C8E6D0)
Joie, Fierté, Admiration, Intérêt, Amusement

### Agréable mais dépassé·e (forme organique — #F5DDD0)
Plaisir, Contentement, Amour, Soulagement, Compassion

### Difficile mais en contrôle (carré arrondi — #DDD4ED)
Colère, Mépris, Haine, Dégoût, Honte

### Difficile et dépassé·e (rectangle arrondi — #C8D8E8)
Tristesse, Culpabilité, Regret, Déception, Peur

## Contraintes importantes
- Stockage local SQLite uniquement pour le POC
- Texte en français dans l'interface
- Inclure fier·e / dépassé·e (écriture inclusive)
- Touch targets minimum 48dp
- Le bocal utilise un ClipPath pour masquer les formes qui dépassent
