import 'package:flutter/material.dart';

class TransactionModel {
  final String id;
  final double amount;
  final String category;
  final DateTime date; // Full date (year, month, day, etc.)
  final TimeOfDay time; // Time in hours and minutes
  final String description;
  final bool isIncome;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.time,
    required this.description,
    required this.isIncome,
  });

  /// Convert `TransactionModel` to `Map<String, dynamic>` for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(), // Store date as ISO8601 string
      'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}', // Time in "HH:mm" format
      'description': description,
      'isIncome': isIncome,
    };
  }

  /// Convert Firestore `Map<String, dynamic>` to `TransactionModel`
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    String timeString = map['time'] ?? '00:00'; // Default to '00:00' if time is missing
    final timeParts = timeString.split(':'); // Split time into hours and minutes

    return TransactionModel(
      id: map['id'] ?? '', // Default to an empty string if ID is missing
      amount: (map['amount'] ?? 0.0).toDouble(), // Safely handle amount as double
      category: map['category'] ?? '', // Default to an empty category
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()), // Parse or default to current date
      time: TimeOfDay(
        hour: int.tryParse(timeParts[0]) ?? 0, // Parse or default to 0 hours
        minute: int.tryParse(timeParts[1]) ?? 0, // Parse or default to 0 minutes
      ),
      description: map['description'] ?? '', // Default to an empty description
      isIncome: map['isIncome'] ?? false, // Default to false if not provided
    );
  }


}
