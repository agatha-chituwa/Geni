import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMode {
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String id;

  PaymentMode({
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory PaymentMode.fromMap(Map<String, dynamic> data) {
    return PaymentMode(
      name: data['Name'] as String,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      id: data['id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'id': id,
    };
  }
}