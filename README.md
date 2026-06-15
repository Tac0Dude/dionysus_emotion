# Dionysus — monitoring émotionnel pour parents en néonatologie

Application Flutter destinée aux **parents de prématurés hospitalisés en NICU**.
Elle leur offre un espace simple et bienveillant pour consigner ce qu'ils
ressentent au quotidien, suivre l'évolution de leurs émotions dans le temps, et,
s'ils le souhaitent, partager ce suivi avec leur co-parent.

Le modèle émotionnel s'appuie sur la **Geneva Emotion Wheel (GEW)** : chaque
émotion appartient à l'un des quatre quadrants (agréable/difficile ×
contrôle/dépassement).

---

## ✨ Fonctionnalités

- **Onboarding** en 5 écrans : prénom du parent, prénom du bébé, date de
  naissance et terme, phase d'hospitalisation, confirmation.
- **Saisie émotionnelle guidée** : quadrant → émotion → intensité (1–5) →
  déclencheur optionnel (activité / lieu).
- **Messages de validation bienveillants** : après chaque saisie, une phrase
  choisie aléatoirement parmi 3 par émotion (60 phrases au total). Pour les
  émotions difficiles à forte intensité, des **ressources d'aide** sont
  proposées avec liens directs (association Né Trop Tôt, néonatologie CHUV,
  équipe soignante).
- **Historique « bocal »** : les saisies tombent dans un bocal sous forme de
  bulles colorées (couleur = quadrant) ; les nouvelles entrées depuis la
  dernière consultation s'animent puis scintillent.
- **Détail par jour et par saisie**, calendrier mensuel, filtres de période.
- **Changement de phase** (admission, hospitalisation, etc.) accessible depuis
  l'écran de saisie.
- **Widget Android interactif** : enregistrer une émotion directement depuis
  l'écran d'accueil, sans ouvrir l'app.
- **Partage co-parent** (optionnel, sur consentement) : appairage par QR code,
  synchronisation des saisies en temps réel via Supabase.
- **Verrouillage de l'app** : code PIN + authentification biométrique.
- Interface **100 % française**, écriture inclusive (fier·e, dépassé·e),
  cibles tactiles ≥ 48 dp, Material 3, police Nunito.

> Les maquettes de référence de chaque écran sont dans `docs/screens/`.

---

## 🧱 Stack technique

| Domaine            | Choix                                             |
|--------------------|---------------------------------------------------|
| Framework          | Flutter (stable) / Dart                           |
| State management   | Riverpod                                          |
| Base locale        | SQLite via **Drift** (source de vérité)           |
| Backend co-parent  | **Supabase** (auth anonyme, Realtime, RLS)        |
| Widget natif       | `home_widget` + code Kotlin Android               |
| UI                 | Material 3, Google Fonts (Nunito)                 |
| Sécurité           | `local_auth`, `flutter_secure_storage`, `crypto`  |

### Architecture

Clean Architecture avec pattern Repository :

```
lib/
├── config/            # Configuration (Supabase)
├── data/              # Implémentations : base Drift, repositories, sync, sécurité
│   ├── database/      # Tables Drift, code généré, seed
│   └── repositories/  # Repositories concrets + mappers domaine↔Drift
├── domain/            # Entités et interfaces de repositories (sans dépendance Flutter)
├── presentation/      # Écrans et widgets, organisés par feature
│   ├── onboarding/  entry/  history/  coparent/  settings/  security/  …
└── widget/            # Pont app ↔ widget Android (isolate d'arrière-plan)
```

La base SQLite locale est **l'unique source de vérité**. Supabase ne reçoit
qu'une copie dénormalisée des saisies, et uniquement si le parent a consenti au
partage.

---

## 🚀 Démarrage

### Prérequis

- **Flutter** 3.38+ (SDK Dart ≥ 3.10) — `flutter doctor` doit être au vert.
- **Android SDK** (minSdk 23) pour cibler Android. Le widget interactif est
  spécifique à Android.

### Installation

```bash
git clone https://github.com/Tac0Dude/dionysus_emotion.git
cd dionysus_emotion
flutter pub get
```

Le projet utilise la génération de code Drift. Le code généré
(`app_database.g.dart`) est versionné, mais après une modification des tables :

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Lancer l'app

```bash
flutter run            # sur un appareil/émulateur connecté
```

> Le **widget Android** ne fonctionne de manière autonome qu'en build
> **release** (compilation AOT). En debug, il nécessite que l'app soit lancée
> depuis l'IDE (machine hôte connectée).

### Build d'un APK release

```bash
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk
```

Pour l'installer sur un appareil de test : activer « installer depuis des
sources inconnues », puis ouvrir l'APK (un avertissement Play Protect peut
apparaître ; choisir « Installer quand même »).

> L'APK est actuellement signé avec la **clé debug** — suffisant pour des tests.
> Pour une distribution durable avec mises à jour, configurer un keystore
> release dédié.

---

## ☁️ Backend co-parent (Supabase, optionnel)

Le partage co-parent est **facultatif** : sans backend configuré, l'app
fonctionne intégralement en local.

La configuration vit dans `lib/config/supabase_config.dart` (URL + clé `anon`,
publique par conception — la sécurité repose sur le **Row Level Security**).
Les valeurs peuvent être surchargées au build :

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://votre-projet.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=votre_cle_anon
```

Le schéma de base et les politiques RLS sont fournis dans
[`supabase/setup.sql`](supabase/setup.sql) (voir `supabase/README.md`).

---

## 🗃️ Modèle de données (local)

`parent`, `stage`, `entry`, `emotion`, `quadrant`, `activity`, `location`.
Une saisie (`entry`) référence une émotion, une intensité (1–5), et
optionnellement une activité et un lieu. Le détail complet est décrit dans
[`CLAUDE.md`](CLAUDE.md).

---

## 🧪 Tests & qualité

```bash
flutter analyze        # analyse statique
flutter test           # tests
```

---

## 📁 Ressources du dépôt

- `docs/screens/` — maquettes de référence par écran.
- `docs/sentences.txt` — phrases de validation bienveillantes (3 par émotion).
- `supabase/` — schéma SQL et documentation du backend partagé.
