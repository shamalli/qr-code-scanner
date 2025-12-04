import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/card_service.dart';

class AddEditCardScreen extends StatefulWidget {
  final CardModel? card;
  final String? barcode;

  const AddEditCardScreen({super.key, this.card, this.barcode});

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final CardService _cardService = CardService();

  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _notesController = TextEditingController();

  CardColor _selectedCardColor = CardColor.blue;
  String? _barcode;

  @override
  void initState() {
    super.initState();
    _barcode = widget.barcode;

    if (widget.card != null) {
      _fillFormWithCardData(widget.card!);
    }

    if (_barcode != null) {
      _cardNumberController.text = _barcode!;
    }
  }

  void _fillFormWithCardData(CardModel card) {
    _cardNameController.text = card.cardName;
    _cardNumberController.text = card.cardNumber;
    _companyNameController.text = card.companyName ?? '';
    _notesController.text = card.notes ?? '';
    _selectedCardColor = card.cardColor;
    _barcode = card.barcode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card == null ? 'Добавить карту' : 'Редактировать карту'),
        actions: [
          if (widget.card != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteCard,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<CardColor>(
                value: _selectedCardColor,
                items: CardColor.values.map((color) {
                  return DropdownMenuItem(
                    value: color,
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          color: color.color,
                          margin: const EdgeInsets.only(right: 8),
                        ),
                        Text(color.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCardColor = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Цвет карты',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNameController,
                decoration: const InputDecoration(
                  labelText: 'Название карты *',
                  border: OutlineInputBorder(),
                  hintText: 'Скидочная карта Пятерочка',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название карты';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Номер карты *',
                  border: OutlineInputBorder(),
                  hintText: '1234567890',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите номер карты';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Магазин/Компания',
                  border: OutlineInputBorder(),
                  hintText: 'Пятерочка',
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'QR-код',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _barcode != null
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _barcode!,
                            style: const TextStyle(
                              fontFamily: 'Monospace',
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 16),
                              const SizedBox(width: 4),
                              const Text(
                                'QR-код отсканирован',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      )
                          : const Text(
                        'QR-код не отсканирован',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Здесь можно добавить повторное сканирование
                          // или очистку QR-кода
                          if (_barcode != null) {
                            setState(() {
                              _barcode = null;
                            });
                          }
                        },
                        icon: Icon(_barcode != null
                            ? Icons.clear
                            : Icons.qr_code_scanner),
                        label: Text(_barcode != null
                            ? 'Очистить QR-код'
                            : 'Сканировать QR-код'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Заметки',
                  border: OutlineInputBorder(),
                  hintText: 'Дополнительная информация',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveCard,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(widget.card == null ? 'Добавить карту' : 'Сохранить изменения'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveCard() async {
    if (_formKey.currentState!.validate()) {
      final card = CardModel(
        id: widget.card?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        cardName: _cardNameController.text,
        cardNumber: _cardNumberController.text,
        barcode: _barcode,
        companyName: _companyNameController.text.isEmpty ? null : _companyNameController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        createdAt: widget.card?.createdAt ?? DateTime.now(),
        cardColor: _selectedCardColor,
      );

      await _cardService.saveCard(card);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _deleteCard() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить карту?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.card != null) {
      await _cardService.deleteCard(widget.card!.id);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _companyNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}