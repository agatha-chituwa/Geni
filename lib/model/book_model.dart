import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  String name;
  String description;
  final DateTime createdAt;
  DateTime updatedAt;
  DocumentReference? ref;
  double balance = 0.0;

  Book({
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.balance = 0.0,
    this.ref,
  });

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(
      name: data['Name'] as String,
      description: data['Description'] as String,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      balance: data['Balance'] as double,
      ref: data['ref'] as DocumentReference?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Description': description,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'Balance': balance,
      'ref': ref,
    };
  }
}