import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/card_service.dart';
import '../services/barcode_scanner_service.dart';
import 'add_edit_card_screen.dart';
import 'card_details_screen.dart';
import 'camera_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardService _cardService = CardService();
  final BarcodeScannerService _barcodeScanner = BarcodeScannerService();
  List<CardModel> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await _cardService.getCards();
    setState(() {
      _cards = cards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Скидочные карты'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _cards.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Нет скидочных карт',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Добавьте карту вручную или сканируйте QR-код',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return _buildCardItem(card);
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'scan_btn',
            onPressed: _scanBarcode,
            backgroundColor: Colors.green,
            child: const Icon(Icons.qr_code_scanner, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'add_btn',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditCardScreen(),
                ),
              ).then((_) => _loadCards());
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem(CardModel card) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardDetailsScreen(card: card),
          ),
        ).then((_) => _loadCards());
      },
      onLongPress: () => _showDeleteDialog(card),
      child: Card(
        color: card.cardColor.color.withOpacity(0.1),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.local_offer,
                color: card.cardColor.color,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                card.cardName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                card.cardNumber,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              if (card.companyName != null) ...[
                const SizedBox(height: 4),
                Text(
                  card.companyName!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const Spacer(),
              if (card.barcode != null)
                Row(
                  children: [
                    Icon(Icons.qr_code, size: 12, color: card.cardColor.color),
                    const SizedBox(width: 4),
                    Text(
                      'QR-код',
                      style: TextStyle(
                        fontSize: 10,
                        color: card.cardColor.color,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scanBarcode() async {
    final String? scannedBarcode = await _barcodeScanner.scanBarcode();

    print('scannedBarcode');

    if (scannedBarcode != null && mounted) {
      // Автоматически переходим к созданию карты с отсканированным QR-кодом
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddEditCardScreen(barcode: scannedBarcode),
        ),
      ).then((_) => _loadCards());
    }
  }

  void _showDeleteDialog(CardModel card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить карту?'),
        content: Text('Вы уверены, что хотите удалить карту "${card.cardName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              await _cardService.deleteCard(card.id);
              _loadCards();
              Navigator.pop(context);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}