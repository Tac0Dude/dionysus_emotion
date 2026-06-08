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

class _AppRoot extends ConsumerWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentStream = ref.watch(currentParentProvider);

    return parentStream.when(
      data: (parent) {
        if (parent == null) {
          return const OnboardingFlow();
        }
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
