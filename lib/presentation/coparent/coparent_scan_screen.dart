import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../theme/app_colors.dart';

/// Scanne le QR d'appairage d'un co-parent et renvoie sa charge utile brute
/// (`"<uid>:<code>"`) via `Navigator.pop`. L'appairage lui-même est fait par
/// l'appelant (CoparentScreen) pour pouvoir afficher le retour utilisateur.
class CoparentScanScreen extends StatefulWidget {
  const CoparentScanScreen({super.key});

  @override
  State<CoparentScanScreen> createState() => _CoparentScanScreenState();
}

class _CoparentScanScreenState extends State<CoparentScanScreen> {
  bool _handled = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final raw = capture.barcodes.isEmpty ? null : capture.barcodes.first.rawValue;
    if (raw == null || raw.isEmpty) return;
    _handled = true;
    Navigator.of(context).pop(raw);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const BackButton(color: AppColors.textPrimary),
        title: const Text(
          'Scanner le QR',
          style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        ),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(onDetect: _onDetect),
          // Repère visuel de cadrage.
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const Positioned(
            bottom: 48,
            left: 32,
            right: 32,
            child: Text(
              'Vise le QR code affiché sur le téléphone de ton co-parent.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
