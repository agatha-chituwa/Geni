import 'package:cloud_firestore/cloud_firestore.dart';

class BookMember {
  final DocumentReference userReference; // Reference to the User document
  final DocumentReference roleReference;  // Reference to the Role document
  final DocumentReference bookReference; // Reference to the Book document
  final DateTime createdAt;
  final DateTime updatedAt;
  final String id;

  BookMember({
    required this.userReference,
    required this.roleReference,
    required this.bookReference,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory BookMember.fromMap(Map<String, dynamic> data) {
    return BookMember(
      userReference: data['userReference'] as DocumentReference,
      roleReference: data['roleReference'] as DocumentReference,
      bookReference: data['bookReference'] as DocumentReference,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      id: data['id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userReference': userReference,
      'roleReference': roleReference,
      'bookReference': bookReference,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'id': id,
    };
  }
}