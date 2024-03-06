import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String id;

  Book({
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(
      name: data['Name'] as String,
      description: data['Description'] as String,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      id: data['id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Description': description,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'id': id,
    };
  }
}