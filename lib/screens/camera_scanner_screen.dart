import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraScannerScreen extends StatefulWidget {
  const CameraScannerScreen({super.key});

  @override
  State<CameraScannerScreen> createState() => _CameraScannerScreenState();
}

class _CameraScannerScreenState extends State<CameraScannerScreen> {
  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      Barcode? barcode = barcodes.barcodes.firstOrNull;

      if (barcode != null) {
        Future.delayed(const Duration(seconds: 2), () {
          print('navpop');
          Navigator.pop(context, barcode.displayValue); // return data
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканируйте QR-код')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(onDetect: _handleBarcode),
          _buildScannerOverlay(),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    const Color gCol = Color(0xFF00FF00);
    const Color wCol = Color(0xFFFFFFFF);
    return Center(
      child: Container(
        width: 450,
        height: 450,
        decoration: BoxDecoration(
          border: Border.all(color: gCol, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, color: gCol, size: 40),
            SizedBox(height: 8),
            Text(
              'Наведите на QR-код',
              style: TextStyle(color: wCol, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}