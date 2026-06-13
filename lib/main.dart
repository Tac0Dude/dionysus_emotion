import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'data/providers.dart';
import 'presentation/entry/screens/quadrant_selection_screen.dart';
import 'presentation/onboarding/onboarding_flow.dart';
import 'presentation/security/lock_gate.dart';
import 'presentation/theme/app_colors.dart';
import 'presentation/theme/app_theme.dart';
import 'widget/widget_callback.dart';
import 'widget/widget_sync.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.registerInteractivityCallback(widgetBackgroundCallback);
  await _initSupabase();
  runApp(const ProviderScope(child: DionysusApp()));
}

/// Initialise Supabase et assure une session anonyme (identité du parent pour le
/// partage co-parent). Tolérant : si le backend n'est pas encore configuré ou
/// indisponible, l'app continue de fonctionner en local (sans co-parent).
Future<void> _initSupabase() async {
  if (!SupabaseConfig.isConfigured) return;
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      // La clé anon (legacy) comme la clé publishable alimentent la même clé
      // client ; on passe par le paramètre non déprécié.
      publishableKey: SupabaseConfig.anonKey,
    );
    final auth = Supabase.instance.client.auth;
    if (auth.currentSession == null) {
      await auth.signInAnonymously();
    }
  } catch (_) {
    // Réseau indisponible / backend non prêt : on n'empêche pas le lancement.
  }
}

class DionysusApp extends StatelessWidget {
  const DionysusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dionysus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [Locale('fr', 'FR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const LockGate(child: _AppRoot()),
    );
  }
}

class _AppRoot extends ConsumerStatefulWidget {
  const _AppRoot();

  @override
  ConsumerState<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<_AppRoot>
    with WidgetsBindingObserver {
  bool _widgetSynced = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Au retour au premier plan, on pousse vers le backend les saisies faites
    // entre-temps (notamment via le widget, sur une autre connexion SQLite).
    if (state == AppLifecycleState.resumed) {
      ref.read(sharedEntrySyncProvider).pushPending();
    }
  }

  /// Aligne le widget natif sur la dernière saisie de la base au lancement, et
  /// pousse les saisies vers le backend partagé. Déclenché une seule fois, après
  /// le premier frame (quand un parent existe).
  void _syncOnce() {
    if (_widgetSynced) return;
    _widgetSynced = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetSync.refreshFromDb(
        parentRepo: ref.read(parentRepositoryProvider),
        entryRepo: ref.read(entryRepositoryProvider),
        referenceRepo: ref.read(referenceRepositoryProvider),
      );
      ref.read(sharedEntrySyncProvider).pushPending();
    });
  }

  @override
  Widget build(BuildContext context) {
    final parentStream = ref.watch(currentParentProvider);

    return parentStream.when(
      data: (parent) {
        if (parent == null) {
          return const OnboardingFlow();
        }
        _syncOnce();
        return const QuadrantSelectionScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Erreur : $error')),
      ),
    );
  }
}
