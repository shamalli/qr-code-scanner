import 'package:flutter/material.dart';
import 'services/barcode_scanner_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CardHolderApp());
}

class CardHolderApp extends StatelessWidget {
  const CardHolderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Скидочные карты',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}