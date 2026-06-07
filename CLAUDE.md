# Dionysus — Module de monitoring émotionnel

## Contexte
Application Flutter destinée aux parents de prématurés hospitalisés en NICU.
Module standalone qui s'intègre à l'application Dionysus existante.

## Stack technique
- Flutter (latest stable)
- SQLite via drift ou sqflite
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

## Messages de validation
[colle ici les 20 messages que tu as rédigés]

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

## Contraintes importantes
- Stockage local SQLite uniquement pour le POC
- Pas d'IA
- Texte en français dans l'interface
- Inclure fier·e / dépassé·e (écriture inclusive)
- Touch targets minimum 48dp
- Le bocal utilise un ClipPath pour masquer les formes qui dépassent