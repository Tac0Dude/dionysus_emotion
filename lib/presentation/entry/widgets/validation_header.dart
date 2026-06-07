import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class ValidationHeader extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final bool emphasizeSubtitle;

  const ValidationHeader({
    super.key,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.emphasizeSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _BottomArcClipper(),
      child: Container(
        color: color,
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: emphasizeSubtitle ? 28 : 22,
                fontWeight:
                    emphasizeSubtitle ? FontWeight.w700 : FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 36);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 28,
      size.width,
      size.height - 36,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
