import 'package:cloud_firestore/cloud_firestore.dart';

class Role {
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String id;

  Role({
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory Role.fromMap(Map<String, dynamic> data) {
    return Role(
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