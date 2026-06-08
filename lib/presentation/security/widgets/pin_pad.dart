import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';

/// Pavé numérique de saisie d'un code PIN : indicateur à points + clavier.
///
/// [onCompleted] est appelé quand [length] chiffres sont saisis. S'il renvoie
/// `false`, le champ tremble et se réinitialise (code refusé) ; s'il renvoie
/// `true`, le champ se vide simplement pour la saisie suivante.
class PinPad extends StatefulWidget {
  final int length;
  final Future<bool> Function(String pin) onCompleted;
  final Widget? leftAction;

  const PinPad({
    super.key,
    this.length = 4,
    required this.onCompleted,
    this.leftAction,
  });

  @override
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> with SingleTickerProviderStateMixin {
  String _entered = '';
  bool _busy = false;
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _onDigit(String digit) async {
    if (_busy || _entered.length >= widget.length) return;
    setState(() => _entered += digit);
    if (_entered.length == widget.length) {
      await _submit();
    }
  }

  void _onBackspace() {
    if (_busy || _entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    final accepted = await widget.onCompleted(_entered);
    if (!mounted) return;
    if (!accepted) {
      HapticFeedback.heavyImpact();
      _shakeController.forward(from: 0);
    }
    setState(() {
      _entered = '';
      _busy = false;
    });
  }

  /// Oscillation horizontale amortie pour signaler un code refusé.
  double _shakeOffset(double t) {
    if (t == 0) return 0;
    return 18 * (1 - t) * math.sin(t * 3 * 2 * math.pi);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeOffset(_shakeController.value), 0),
              child: child,
            );
          },
          child: _Dots(length: widget.length, filled: _entered.length),
        ),
        const SizedBox(height: 40),
        _Keypad(
          onDigit: _onDigit,
          onBackspace: _onBackspace,
          leftAction: widget.leftAction,
        ),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  final int length;
  final int filled;

  const _Dots({required this.length, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < length; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < filled ? AppColors.primary : Colors.transparent,
              border: Border.all(
                color: i < filled ? AppColors.primary : AppColors.divider,
                width: 1.6,
              ),
            ),
          ),
      ],
    );
  }
}

class _Keypad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final Widget? leftAction;

  const _Keypad({
    required this.onDigit,
    required this.onBackspace,
    this.leftAction,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in const [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
          ])
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final d in row) _DigitKey(digit: d, onTap: () => onDigit(d)),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SlotKey(child: leftAction),
              _DigitKey(digit: '0', onTap: () => onDigit('0')),
              _SlotKey(
                child: _KeyButton(
                  onTap: onBackspace,
                  child: const Icon(
                    Icons.backspace_outlined,
                    color: AppColors.textPrimary,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DigitKey extends StatelessWidget {
  final String digit;
  final VoidCallback onTap;

  const _DigitKey({required this.digit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _KeyButton(
      onTap: onTap,
      child: Text(
        digit,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _SlotKey extends StatelessWidget {
  final Widget? child;

  const _SlotKey({this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 76, height: 76, child: Center(child: child));
  }
}

class _KeyButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _KeyButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(width: 64, height: 64, child: Center(child: child)),
        ),
      ),
    );
  }
}
