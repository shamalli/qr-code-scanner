import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/card_model.dart';

class CardService {
  static const String _storageKey = 'discount_cards';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<CardModel>> getCards() async {
    try {
      final String? cardsJson = await _storage.read(key: _storageKey);
      if (cardsJson == null) return [];

      final List<dynamic> cardsList = json.decode(cardsJson);
      return cardsList.map((cardJson) => CardModel(
        id: cardJson['id'],
        cardName: cardJson['cardName'],
        cardNumber: cardJson['cardNumber'],
        barcode: cardJson['barcode'],
        companyName: cardJson['companyName'],
        notes: cardJson['notes'],
        createdAt: DateTime.parse(cardJson['createdAt']),
        cardColor: CardColor.values[cardJson['cardColor']],
      )).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveCard(CardModel card) async {
    final List<CardModel> cards = await getCards();
    final int existingIndex = cards.indexWhere((c) => c.id == card.id);

    if (existingIndex >= 0) {
      cards[existingIndex] = card;
    } else {
      cards.add(card);
    }

    await _saveCards(cards);
  }

  Future<void> deleteCard(String cardId) async {
    final List<CardModel> cards = await getCards();
    cards.removeWhere((card) => card.id == cardId);
    await _saveCards(cards);
  }

  Future<void> _saveCards(List<CardModel> cards) async {
    final List<Map<String, dynamic>> cardsJson = cards.map((card) => {
      'id': card.id,
      'cardName': card.cardName,
      'cardNumber': card.cardNumber,
      'barcode': card.barcode,
      'companyName': card.companyName,
      'notes': card.notes,
      'createdAt': card.createdAt.toIso8601String(),
      'cardColor': card.cardColor.index,
    }).toList();

    await _storage.write(
      key: _storageKey,
      value: json.encode(cardsJson),
    );
  }
}