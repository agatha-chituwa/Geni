import 'package:cloud_firestore/cloud_firestore.dart';

class UserBook {
  final DocumentReference userReference; // Reference to the User document
  final DocumentReference roleReference;  // Reference to the Role document
  final DocumentReference bookReference; // Reference to the Book document
  final DateTime createdAt;
  final DateTime updatedAt;
  final DocumentReference ref; // Reference to the UserBook document itself

  UserBook({
    required this.userReference,
    required this.roleReference,
    required this.bookReference,
    required this.createdAt,
    required this.updatedAt,
    required this.ref,
  });

  factory UserBook.fromMap(Map<String, dynamic> data) {
    return UserBook(
      userReference: data['userReference'] as DocumentReference,
      roleReference: data['roleReference'] as DocumentReference,
      bookReference: data['bookReference'] as DocumentReference,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      ref: data['ref'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userReference': userReference,
      'roleReference': roleReference,
      'bookReference': bookReference,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'ref': ref,
    };
  }
}