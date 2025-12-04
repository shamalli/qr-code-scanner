import 'package:flutter/material.dart';
import '../models/card_model.dart';
import 'add_edit_card_screen.dart';

class CardDetailsScreen extends StatelessWidget {
  final CardModel card;

  const CardDetailsScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.cardName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditCardScreen(card: card),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Имя карты', card.cardName),
            _buildInfoCard('Номер карты', _formatCardNumber(card.cardNumber)),
            if (card.companyName != null)
              _buildInfoCard('Владелец', card.companyName!),
            if (card.notes != null)
              _buildInfoCard('Заметки', card.notes!),
            _buildInfoCard('Добавлена', '${card.createdAt.day}.${card.createdAt.month}.${card.createdAt.year}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCardNumber(String number) {
    if (number.length != 16) return number;
    return '${number.substring(0, 4)} ${number.substring(4, 8)} ${number.substring(8, 12)} ${number.substring(12)}';
  }
}