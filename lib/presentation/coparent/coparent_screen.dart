import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../data/providers.dart';
import '../../domain/entities/coparent_profile.dart';
import '../../domain/entities/parent.dart';
import '../../domain/entities/shared_emotion.dart';
import '../../domain/repositories/coparent_repository.dart';
import '../common/intensity_labels.dart';
import '../entry/quadrant_visuals.dart';
import '../history/widgets/jar.dart';
import '../history/widgets/period_toggle.dart';
import '../shell/bottom_nav.dart';
import '../theme/app_colors.dart';
import 'coparent_scan_screen.dart';

/// Charge utile du QR de l'utilisateur courant (profil garanti créé au passage).
final _myPairingPayloadProvider = FutureProvider<String?>((ref) async {
  final coparent = ref.watch(coparentRepositoryProvider);
  if (!coparent.isAvailable) return null;
  final parent = await ref.watch(parentRepositoryProvider).getCurrentParent();
  await coparent.ensureProfile(parent?.firstName ?? '');
  return coparent.myPairingPayload();
});

final _coparentProfileProvider =
    FutureProvider.family<CoparentProfile?, String>((ref, id) {
  return ref.watch(coparentRepositoryProvider).getProfile(id);
});

final _coparentEntriesProvider =
    StreamProvider.family<List<SharedEmotion>, String>((ref, ownerId) {
  return ref.watch(coparentRepositoryProvider).watchSharedEntries(ownerId);
});

class CoparentScreen extends ConsumerWidget {
  const CoparentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(coparentRepositoryProvider);

    Widget body;
    if (!repo.isAvailable) {
      body = const _CenteredMessage(
        'Le partage co-parent n’est pas disponible.\n'
        'Vérifie ta connexion et la configuration du backend.',
      );
    } else {
      final parentAsync = ref.watch(currentParentProvider);
      body = parentAsync.when(
        loading: () => const _Loader(),
        error: (_, _) =>
            const _CenteredMessage('Impossible de charger ton profil.'),
        data: (parent) {
          if (parent == null) {
            return const _CenteredMessage('Profil parent introuvable.');
          }
          // Aucune donnée ne part tant que le parent n'a pas consenti.
          if (!parent.sharingConsent) {
            return _ConsentView(parent: parent);
          }
          final coparentIdAsync = ref.watch(coparentIdProvider);
          return coparentIdAsync.when(
            data: (coparentId) => coparentId == null
                ? const _UnpairedView()
                : _PairedView(coparentId: coparentId),
            loading: () => const _Loader(),
            error: (_, _) => const _PairingErrorView(),
          );
        },
      );
    }

    return Scaffold(
      body: SafeArea(bottom: false, child: body),
      bottomNavigationBar: const BottomNav(currentTab: MainTab.coparent),
    );
  }
}

// --- Consentement -----------------------------------------------------------

class _ConsentView extends ConsumerWidget {
  final Parent parent;

  const _ConsentView({required this.parent});

  Future<void> _accept(BuildContext context, WidgetRef ref) async {
    await ref.read(parentRepositoryProvider).updateSharingConsent(
          parentId: parent.id,
          consent: true,
        );
    // Pousse l'historique existant pour que le co-parent le voie dès l'appairage.
    ref.read(sharedEntrySyncProvider).pushPending();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.cream,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield_outlined,
                  size: 34, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Partager avec ton co-parent',
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const _ConsentPoint(
            icon: Icons.cloud_upload_outlined,
            text:
                'Tes saisies seront envoyées vers un serveur sécurisé pour être '
                'partagées.',
          ),
          const _ConsentPoint(
            icon: Icons.visibility_outlined,
            text:
                'Une fois appairé, ton co-parent pourra consulter ton historique '
                'émotionnel (bocal et dernière émotion).',
          ),
          const _ConsentPoint(
            icon: Icons.lock_outline,
            text:
                'Personne d’autre que ton co-parent appairé n’y a accès. Tu peux '
                'cesser le partage ou supprimer tes données à tout moment.',
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _accept(context, ref),
              child: const Text('J’accepte et je partage'),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'En continuant, tu acceptes l’envoi de ces données.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsentPoint extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ConsentPoint({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Non appairé : QR + scan ------------------------------------------------

class _UnpairedView extends ConsumerWidget {
  const _UnpairedView();

  Future<void> _scan(BuildContext context, WidgetRef ref) async {
    final payload = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const CoparentScanScreen()),
    );
    if (payload == null) return;
    final result =
        await ref.read(coparentRepositoryProvider).linkWith(payload);
    // Bascule immédiatement la vue sans attendre l'événement Realtime du profil.
    if (result == CoparentLinkResult.success) {
      ref.invalidate(coparentIdProvider);
    }
    if (!context.mounted) return;
    final message = switch (result) {
      CoparentLinkResult.success => 'Vous êtes désormais co-parents !',
      CoparentLinkResult.invalidCode => 'QR code invalide.',
      CoparentLinkResult.alreadyPaired => 'L’un de vous a déjà un co-parent.',
      CoparentLinkResult.selfPair => 'C’est ton propre QR code.',
      CoparentLinkResult.notReady => 'Partage indisponible pour l’instant.',
      CoparentLinkResult.error => 'L’appairage a échoué. Réessaie.',
    };
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payloadAsync = ref.watch(_myPairingPayloadProvider);
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Co-parent',
            style: textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Partage ton suivi avec l’autre parent. Montre-lui ce QR code, '
            'ou scanne le sien.',
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
              ),
              child: payloadAsync.when(
                data: (payload) => payload == null
                    ? const SizedBox(
                        width: 220,
                        height: 220,
                        child: Center(
                          child: Text(
                            'QR indisponible',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    : QrImageView(
                        data: payload,
                        version: QrVersions.auto,
                        size: 220,
                        backgroundColor: Colors.white,
                      ),
                loading: () => const SizedBox(
                  width: 220,
                  height: 220,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                error: (_, _) => const SizedBox(
                  width: 220,
                  height: 220,
                  child: Center(child: Text('Erreur')),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _scan(context, ref),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scanner le QR de mon co-parent'),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Erreur d'état d'appairage : échappatoire pour rompre le lien -----------

/// Affiché quand le flux d'état d'appairage lui-même échoue. On ne sait pas si
/// l'utilisateur est appairé ou non : on lui offre quand même de rompre le lien
/// (idempotent côté serveur) pour ne jamais rester coincé, ainsi qu'un réessai.
class _PairingErrorView extends ConsumerWidget {
  const _PairingErrorView();

  Future<void> _confirmUnlink(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rompre l’appairage ?'),
        content: const Text(
          'Si l’appairage est défectueux, le rompre te permet de repartir de '
          'zéro et de ré-appairer un appareil. Vous pourrez vous ré-appairer '
          'plus tard.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Rompre l’appairage'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(coparentRepositoryProvider).unlink();
    ref.invalidate(coparentIdProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Impossible de récupérer l’état d’appairage.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => ref.invalidate(coparentIdProvider),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Réessayer'),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _confirmUnlink(context, ref),
              icon: const Icon(Icons.link_off, size: 18),
              label: const Text('Rompre l’appairage'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Appairé : bocal (filtrable) + dernière émotion (lecture seule) ---------

class _PairedView extends ConsumerStatefulWidget {
  final String coparentId;

  const _PairedView({required this.coparentId});

  @override
  ConsumerState<_PairedView> createState() => _PairedViewState();
}

class _PairedViewState extends ConsumerState<_PairedView> {
  HistoryPeriod _period = HistoryPeriod.week;

  List<SharedEmotion> _inPeriod(List<SharedEmotion> all) {
    final range = periodRange(_period);
    return all
        .where((e) =>
            !e.createdAt.isBefore(range.start) &&
            e.createdAt.isBefore(range.end))
        .toList();
  }

  Future<void> _confirmUnlink() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Arrêter le partage ?'),
        content: const Text(
          'Ton co-parent n’aura plus accès à tes émotions, et tu n’auras plus '
          'accès aux siennes. Vous pourrez vous ré-appairer plus tard.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Arrêter le partage'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(coparentRepositoryProvider).unlink();
    ref.invalidate(coparentIdProvider);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync =
        ref.watch(_coparentProfileProvider(widget.coparentId));
    final entriesAsync =
        ref.watch(_coparentEntriesProvider(widget.coparentId));
    final textTheme = Theme.of(context).textTheme;

    final name = profileAsync.asData?.value?.firstName ?? '';
    final title = name.isEmpty ? 'Mon co-parent' : name;

    // Le header (titre + « Arrêter le partage ») reste toujours affiché, même si
    // le flux des émotions du co-parent ne se charge pas (profil cassé, souci
    // réseau/Realtime…). Sinon l'appairage devient impossible à rompre, ce qui
    // bloque aussi tout nouvel appairage côté serveur (already paired).
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _confirmUnlink,
                icon: const Icon(Icons.link_off, size: 18),
                label: const Text('Arrêter le partage'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Le bocal d’émotions de ton co-parent',
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          entriesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: _Loader(),
            ),
            error: (_, _) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: _CenteredMessage(
                'Impossible de charger les émotions du co-parent pour le moment.',
              ),
            ),
            data: (allEntries) => _buildEntries(allEntries),
          ),
        ],
      ),
    );
  }

  Widget _buildEntries(List<SharedEmotion> allEntries) {
    final periodEntries = _inPeriod(allEntries);
    final bubbles = periodEntries
        .map((e) => EmotionBubbleData(
              id: e.createdAt.millisecondsSinceEpoch,
              emotionName: e.emotionName,
              shape: visualFor(e.quadrantLabel).shape,
              color: visualFor(e.quadrantLabel).color,
              intensity: e.intensity,
              createdAt: e.createdAt,
            ))
        .toList();
    // Dernière émotion : la plus récente, toutes périodes confondues.
    final last = allEntries.isEmpty
        ? null
        : allEntries.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PeriodToggle(
          value: _period,
          onChanged: (p) => setState(() => _period = p),
        ),
        const SizedBox(height: 20),
        // Lecture seule : pas de détail au-delà du bocal brut. Le bocal
        // anime l'arrivée en temps réel d'une nouvelle émotion du co-parent
        // (couvercle qui se soulève + bulle qui tombe).
        Jar(bubbles: bubbles, onTap: (_) {}, animateArrivals: true),
        const SizedBox(height: 24),
        const Text(
          'Dernière émotion enregistrée',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        if (last == null)
          const _CenteredMessage('Aucune émotion partagée pour l’instant.')
        else
          _LastEmotionCard(emotion: last),
      ],
    );
  }
}

class _LastEmotionCard extends StatelessWidget {
  final SharedEmotion emotion;

  const _LastEmotionCard({required this.emotion});

  String _time(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final color = visualFor(emotion.quadrantLabel).color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emotion.emotionName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${intensityLabels[emotion.intensity - 1]} · ${_time(emotion.createdAt)}',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  final String text;

  const _CenteredMessage(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
