import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import 'data/providers.dart';
import 'presentation/entry/screens/quadrant_selection_screen.dart';
import 'presentation/onboarding/onboarding_flow.dart';
import 'presentation/security/lock_gate.dart';
import 'presentation/theme/app_colors.dart';
import 'presentation/theme/app_theme.dart';
import 'widget/widget_callback.dart';
import 'widget/widget_sync.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.registerInteractivityCallback(widgetBackgroundCallback);
  runApp(const ProviderScope(child: DionysusApp()));
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

class _AppRootState extends ConsumerState<_AppRoot> {
  bool _widgetSynced = false;

  /// Aligne le widget natif sur la dernière saisie de la base au lancement,
  /// afin de corriger un état périmé (ex. invitation affichée alors qu'une
  /// saisie récente existe). Déclenché une seule fois, après le premier frame.
  void _syncWidgetOnce() {
    if (_widgetSynced) return;
    _widgetSynced = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetSync.refreshFromDb(
        parentRepo: ref.read(parentRepositoryProvider),
        entryRepo: ref.read(entryRepositoryProvider),
        referenceRepo: ref.read(referenceRepositoryProvider),
      );
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
        _syncWidgetOnce();
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
