import 'package:cloud_firestore/cloud_firestore.dart';

class Business {
  final String name;
  final int numberOfEmployees;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;
  DocumentReference? ref;

  Business({
    required this.name,
    required this.numberOfEmployees,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.ref,
  });

  factory Business.fromMap(Map<String, dynamic> data) {
    return Business(
      name: data['Name'] as String,
      numberOfEmployees: data['numberOfEmployees'] as int,
      location: data['Location'] as String,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      ref: data['ref'] as DocumentReference?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'numberOfEmployees': numberOfEmployees,
      'Location': location,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'ref': ref,
    };
  }
}