import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../entry/quadrant_visuals.dart';
import '../../entry/widgets/quadrant_tile.dart';
import '../../theme/app_colors.dart';

class EmotionBubbleData {
  final int id;
  final String emotionName;
  final QuadrantShape shape;
  final Color color;
  final int intensity;
  final DateTime createdAt;

  /// Saisie ajoutée depuis la dernière consultation de l'historique : la bulle
  /// scintille pour signaler qu'il s'agit d'un nouvel ajout.
  final bool isNew;

  const EmotionBubbleData({
    required this.id,
    required this.emotionName,
    required this.shape,
    required this.color,
    required this.intensity,
    required this.createdAt,
    this.isNew = false,
  });
}

/// Taille (côté du carré englobant) des bulles selon l'intensité (1 à 5).
/// Les quatre formes s'inscrivent dans un carré de cette taille ; seule
/// l'intensité fait varier la taille.
const _bubbleSizes = <double>[40, 52, 64, 78, 92];

/// Petit espacement réservé autour de chaque bulle dans le packing, pour
/// éviter qu'elles soient collées.
const _bubbleGap = 0.5;

class _Placed {
  final EmotionBubbleData data;
  final double x;
  final double yFromBottom;
  final double width;
  final double height;
  const _Placed({
    required this.data,
    required this.x,
    required this.yFromBottom,
    required this.width,
    required this.height,
  });
}

class Jar extends StatefulWidget {
  final List<EmotionBubbleData> bubbles;
  final void Function(EmotionBubbleData) onTap;

  /// Quand vrai, l'arrivée d'une saisie plus récente que toutes les autres
  /// déclenche une animation : le couvercle se soulève et la bulle tombe en
  /// place (utilisé sur la page co-parent, mis à jour en temps réel).
  final bool animateArrivals;

  const Jar({
    super.key,
    required this.bubbles,
    required this.onTap,
    this.animateArrivals = false,
  });

  @override
  State<Jar> createState() => _JarState();
}

class _JarState extends State<Jar> with SingleTickerProviderStateMixin {
  late final AnimationController _drop;
  int? _droppingId;
  late Set<int> _knownIds;
  DateTime? _latestSeen;

  @override
  void initState() {
    super.initState();
    _drop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _knownIds = {for (final b in widget.bubbles) b.id};
    _latestSeen = _maxCreatedAt(widget.bubbles);
  }

  @override
  void didUpdateWidget(covariant Jar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newcomers =
        widget.bubbles.where((b) => !_knownIds.contains(b.id)).toList();
    final prevLatest = _latestSeen;
    _knownIds = {for (final b in widget.bubbles) b.id};
    _latestSeen = _maxCreatedAt(widget.bubbles);

    if (!widget.animateArrivals || newcomers.isEmpty) return;
    // On n'anime que pour un arrivage réellement plus récent que tout ce qu'on
    // connaissait — pas pour un changement de période (qui fait apparaître des
    // saisies plus anciennes) ni pour le chargement initial.
    if (prevLatest == null && newcomers.length != 1) return;
    EmotionBubbleData? arrival;
    for (final b in newcomers) {
      if (prevLatest != null && !b.createdAt.isAfter(prevLatest)) continue;
      if (arrival == null || b.createdAt.isAfter(arrival.createdAt)) {
        arrival = b;
      }
    }
    if (arrival == null) return;
    final dropId = arrival.id;
    setState(() => _droppingId = dropId);
    _drop.forward(from: 0).whenComplete(() {
      if (mounted) setState(() => _droppingId = null);
    });
  }

  @override
  void dispose() {
    _drop.dispose();
    super.dispose();
  }

  DateTime? _maxCreatedAt(List<EmotionBubbleData> list) {
    DateTime? max;
    for (final b in list) {
      if (max == null || b.createdAt.isAfter(max)) max = b.createdAt;
    }
    return max;
  }

  /// Facteur d'ouverture du couvercle (0 = fermé, 1 = soulevé) selon
  /// l'avancement de l'animation : il s'ouvre, reste ouvert pendant la chute,
  /// puis se referme.
  double _lidOpen(double v) {
    if (_droppingId == null) return 0;
    if (v < 0.18) return Curves.easeOut.transform(v / 0.18);
    if (v < 0.78) return 1;
    return 1 - Curves.easeIn.transform((v - 0.78) / 0.22);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      // Le couvercle se soulève au-dessus du bocal pendant l'animation.
      clipBehavior: Clip.none,
      children: [
        AnimatedBuilder(
          animation: _drop,
          builder: (context, child) {
            final open = _lidOpen(_drop.value);
            return Transform.translate(
              offset: Offset(0, -22 * open),
              child: Transform.rotate(angle: -0.06 * open, child: child),
            );
          },
          child: _buildLid(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 220),
            padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.divider, width: 1),
            ),
            child: widget.bubbles.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Text(
                        'Pas encore de saisie sur cette période.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final placed = _pack(widget.bubbles, width);
                      final pileHeight = placed.isEmpty
                          ? 0.0
                          : placed
                              .map((p) => p.yFromBottom + p.height)
                              .reduce(math.max);
                      final stackHeight = math.max(pileHeight, 180.0);
                      return SizedBox(
                        width: width,
                        height: stackHeight,
                        child: AnimatedBuilder(
                          animation: _drop,
                          builder: (context, _) {
                            return Stack(
                              clipBehavior: Clip.hardEdge,
                              children: [
                                for (final p in placed)
                                  _positionedBubble(p, stackHeight),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  /// Bulle positionnée. La bulle en cours de chute interpole sa hauteur depuis
  /// le haut du bocal jusqu'à sa place, avec un rebond (effet « tombe en place »).
  Widget _positionedBubble(_Placed p, double stackHeight) {
    final targetTop = stackHeight - p.yFromBottom - p.height;
    var top = targetTop;
    if (p.data.id == _droppingId) {
      final startTop = -p.height - 8.0;
      final dropT = ((_drop.value - 0.12) / 0.78).clamp(0.0, 1.0);
      top = startTop +
          (targetTop - startTop) * Curves.bounceOut.transform(dropT);
    }
    return Positioned(
      key: ValueKey(p.data.id),
      left: p.x,
      top: top,
      width: p.width,
      height: p.height,
      child: _Bubble(placed: p, onTap: () => widget.onTap(p.data)),
    );
  }

  Widget _buildLid() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          height: 26,
          decoration: const BoxDecoration(
            color: Color(0xFF2D2826),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
        Container(
          width: 230,
          height: 10,
          decoration: const BoxDecoration(
            color: Color(0xFF2D2826),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
          ),
        ),
      ],
    );
  }
}

List<_Placed> _pack(List<EmotionBubbleData> bubbles, double width) {
  if (width <= 0 || bubbles.isEmpty) return const [];

  // Les émotions les plus anciennes se tassent au fond en premier ; les plus
  // récentes viennent ensuite par-dessus, comme des dépôts successifs. Tri
  // stable (id en départage) pour un rendu figé.
  final sorted = [...bubbles]..sort((a, b) {
      final c = a.createdAt.compareTo(b.createdAt);
      if (c != 0) return c;
      return a.id.compareTo(b.id);
    });

  final jarWidth = width.floor();
  // skyline[k] = hauteur déjà remplie à la colonne k (depuis le bas).
  final skyline = List<double>.filled(jarWidth, 0.0);
  final placed = <_Placed>[];
  final center = jarWidth / 2;

  for (final bubble in sorted) {
    final size = math.min(
      _bubbleSizes[bubble.intensity - 1],
      jarWidth.toDouble(),
    );
    // On réserve un peu plus que la bulle (footprint) et on la dessine centrée
    // dedans : la marge `inset` autour produit un petit écart entre voisines.
    final footprint = math.min(size + _bubbleGap, jarWidth.toDouble());
    final inset = (footprint - size) / 2;
    final span = footprint.ceil();

    // Bulle aussi large que le bocal : on la pose à plat au-dessus du tas.
    if (span >= jarWidth) {
      final base = skyline.reduce(math.max);
      for (var k = 0; k < jarWidth; k++) {
        skyline[k] = base + footprint;
      }
      placed.add(_Placed(
        data: bubble,
        x: inset,
        yFromBottom: base + inset,
        width: math.min(size, jarWidth.toDouble()),
        height: size,
      ));
      continue;
    }

    // Comportement « liquide » : on cherche la position dont la base est la
    // plus basse (remplit le creux le plus profond avant de monter). À base
    // égale, on privilégie le centre pour former un tas naturel.
    final maxStart = jarWidth - span;
    var bestBase = double.infinity;
    var bestX = 0;
    var bestCenterDist = double.infinity;

    for (var x = 0; x <= maxStart; x++) {
      var base = 0.0;
      for (var k = x; k < x + span; k++) {
        if (skyline[k] > base) base = skyline[k];
      }
      final centerDist = (x + span / 2 - center).abs();
      if (base < bestBase - 0.5 ||
          (base <= bestBase + 0.5 && centerDist < bestCenterDist)) {
        bestBase = base;
        bestX = x;
        bestCenterDist = centerDist;
      }
    }

    final newTop = bestBase + footprint;
    for (var k = bestX; k < bestX + span; k++) {
      skyline[k] = newTop;
    }
    placed.add(_Placed(
      data: bubble,
      x: bestX + inset,
      yFromBottom: bestBase + inset,
      width: size,
      height: size,
    ));
  }
  return placed;
}

class _Bubble extends StatefulWidget {
  final _Placed placed;
  final VoidCallback onTap;

  const _Bubble({required this.placed, required this.onTap});

  @override
  State<_Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<_Bubble>
    with SingleTickerProviderStateMixin {
  AnimationController? _twinkle;

  @override
  void initState() {
    super.initState();
    if (widget.placed.data.isNew) {
      _twinkle = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900),
      );
      // Léger décalage de phase par bulle pour un scintillement non synchrone.
      final delayMs = (widget.placed.data.id % 6) * 130;
      Future.delayed(Duration(milliseconds: delayMs), () {
        if (mounted) _twinkle?.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    _twinkle?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bubble = _buildBubble(context);
    final twinkle = _twinkle;
    if (twinkle == null) return bubble;
    return AnimatedBuilder(
      animation: twinkle,
      child: bubble,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(twinkle.value);
        return Opacity(
          opacity: 0.55 + 0.45 * t,
          child: Transform.scale(scale: 1.0 + 0.05 * t, child: child),
        );
      },
    );
  }

  Widget _buildBubble(BuildContext context) {
    final data = widget.placed.data;
    final width = widget.placed.width;
    final height = widget.placed.height;
    final label = Center(
      child: Padding(
        padding: EdgeInsets.all(height * 0.12),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            data.emotionName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );

    // Le blob organique est dessiné par un painter (même silhouette que les
    // tuiles de quadrant) ; il n'a pas de bordure exploitable par InkWell.
    if (data.shape == QuadrantShape.organic) {
      return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: width,
          height: height,
          child: QuadrantShapeBox(
            shape: QuadrantShape.organic,
            color: data.color,
            child: label,
          ),
        ),
      );
    }

    // Quadrant bleu (Difficile et dépassé·e) : deux pilules empilées dans le
    // carré, qui se recouvrent légèrement au centre pour garder le texte lisible.
    if (data.shape == QuadrantShape.roundedRectangle) {
      final pillHeight = height * 0.54;
      return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: pillHeight,
                child: _pill(data.color, pillHeight),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: pillHeight,
                child: _pill(data.color, pillHeight),
              ),
              Positioned.fill(child: label),
            ],
          ),
        ),
      );
    }

    final border = _shapeBorder(data.shape, width, height);
    return Material(
      color: data.color,
      shape: border,
      child: InkWell(
        onTap: widget.onTap,
        customBorder: border,
        child: SizedBox(width: width, height: height, child: label),
      ),
    );
  }

  Widget _pill(Color color, double height) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }

  // Cercle et carré arrondi (les seules formes passant par ce rendu Material).
  // Le blob organique et les pilules bleues ont leur propre rendu plus haut.
  ShapeBorder _shapeBorder(QuadrantShape shape, double width, double height) {
    final shortest = math.min(width, height);
    switch (shape) {
      case QuadrantShape.circle:
        return const CircleBorder();
      case QuadrantShape.roundedSquare:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shortest * 0.28),
        );
      case QuadrantShape.roundedRectangle:
      case QuadrantShape.organic:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shortest * 0.3),
        );
    }
  }
}
