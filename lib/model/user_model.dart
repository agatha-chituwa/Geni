import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geni_app/model/role_model.dart';

class User {
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  String? id;

  List<Role>? roles;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    this.roles,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      name: data['Name'] as String,
      email: data['Email'] as String,
      phone: data['Phone'] as String,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      id: data['id'] as String,
      roles: (data['Roles'] as List?)?.map((role) => Role.fromMap(role)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Email': email,
      'Phone': phone,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'id': id,
      'Roles': roles?.map((role) => role.toMap()).toList(),
    };
  }
}