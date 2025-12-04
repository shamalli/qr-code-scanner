import 'package:flutter/material.dart';
import '../screens/camera_scanner_screen.dart';

class BarcodeScannerService {

  Future<String?> scanBarcode() async {
    try {
      return await Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => const CameraScannerScreen(),
        ),
      );
    } catch (e) {
      debugPrint('Ошибка сканирования: $e');
      return null;
    }
  }
}

// Глобальный ключ для доступа к навигатору
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();