import 'package:flutter/material.dart';

class CardModel {
  final String id;
  final String cardName;
  final String cardNumber;
  final String? barcode;
  final String? companyName;
  final String? notes;
  final DateTime createdAt;
  final CardColor cardColor;

  CardModel({
    required this.id,
    required this.cardName,
    required this.cardNumber,
    this.barcode,
    this.companyName,
    this.notes,
    required this.createdAt,
    this.cardColor = CardColor.blue,
  });

  CardModel copyWith({
    String? id,
    String? cardName,
    String? cardNumber,
    String? barcode,
    String? companyName,
    String? notes,
    DateTime? createdAt,
    CardColor? cardColor,
  }) {
    return CardModel(
      id: id ?? this.id,
      cardName: cardName ?? this.cardName,
      cardNumber: cardNumber ?? this.cardNumber,
      barcode: barcode ?? this.barcode,
      companyName: companyName ?? this.companyName,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      cardColor: cardColor ?? this.cardColor,
    );
  }
}

enum CardColor {
  blue,
  green,
  orange,
  purple,
  red,
}

extension CardColorExtension on CardColor {
  Color get color {
    switch (this) {
      case CardColor.blue:
        return Colors.blue;
      case CardColor.green:
        return Colors.green;
      case CardColor.orange:
        return Colors.orange;
      case CardColor.purple:
        return Colors.purple;
      case CardColor.red:
        return Colors.red;
    }
  }

  String get displayName {
    switch (this) {
      case CardColor.blue:
        return 'Синий';
      case CardColor.green:
        return 'Зеленый';
      case CardColor.orange:
        return 'Оранжевый';
      case CardColor.purple:
        return 'Фиолетовый';
      case CardColor.red:
        return 'Красный';
    }
  }
}