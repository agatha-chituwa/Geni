import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  DocumentReference? ref;


  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    this.ref,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      name: data['Name'] as String,
      email: data['Email'] as String,
      phone: data['Phone'] as String,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      ref: data['ref'] as DocumentReference?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Email': email,
      'Phone': phone,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'ref': ref,
    };
  }
}