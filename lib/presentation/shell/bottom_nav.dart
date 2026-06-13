import 'package:flutter/material.dart';

import '../coparent/coparent_screen.dart';
import '../entry/screens/quadrant_selection_screen.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';
import '../theme/app_colors.dart';

enum MainTab { history, entry, coparent, settings }

class BottomNav extends StatelessWidget {
  final MainTab currentTab;

  const BottomNav({super.key, required this.currentTab});

  void _switchTo(BuildContext context, MainTab tab) {
    if (tab == currentTab) return;
    final Widget destination = switch (tab) {
      MainTab.history => const HistoryScreen(),
      MainTab.entry => const QuadrantSelectionScreen(),
      MainTab.coparent => const CoparentScreen(),
      MainTab.settings => const SettingsScreen(),
    };
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder<void>(
        pageBuilder: (_, _, _) => destination,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.navbar,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Groupe gauche : laisse le bouton central parfaitement centré.
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _NavItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Historique',
                        selected: currentTab == MainTab.history,
                        onTap: () => _switchTo(context, MainTab.history),
                      ),
                    ),
                    Expanded(
                      child: _NavItem(
                        icon: Icons.group_outlined,
                        label: 'Co-parent',
                        selected: currentTab == MainTab.coparent,
                        onTap: () => _switchTo(context, MainTab.coparent),
                      ),
                    ),
                  ],
                ),
              ),
              _CenterButton(
                onTap: () => _switchTo(context, MainTab.entry),
                active: currentTab == MainTab.entry,
              ),
              // Groupe droit (même largeur que le gauche) : Paramètres centré
              // dans sa moitié, ce qui garde le bouton + parfaitement au centre.
              Expanded(
                child: _NavItem(
                  icon: Icons.settings_outlined,
                  label: 'Paramètres',
                  selected: currentTab == MainTab.settings,
                  onTap: () => _switchTo(context, MainTab.settings),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        // Hauteur min pour la cible tactile ; largeur libre (les items se
        // partagent l'espace via Expanded), le libellé se réduit si nécessaire.
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool active;

  const _CenterButton({required this.onTap, required this.active});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Nouvelle saisie',
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        elevation: active ? 4 : 0,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            width: 56,
            height: 56,
            child: Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
