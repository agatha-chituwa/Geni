import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessMember {
  final DocumentReference userReference; // Reference to the User document
  final DocumentReference roleReference;  // Reference to the Role document
  final DocumentReference memberReference; // Reference to another document (unclear)
  final DateTime createdAt;
  final DateTime updatedAt;
  final DocumentReference ref;

  BusinessMember({
    required this.userReference,
    required this.roleReference,
    required this.memberReference,
    required this.createdAt,
    required this.updatedAt,
    required this.ref,
  });

  factory BusinessMember.fromMap(Map<String, dynamic> data) {
    return BusinessMember(
      userReference: data['userReference'] as DocumentReference,
      roleReference: data['roleReference'] as DocumentReference,
      memberReference: data['memberReference'] as DocumentReference,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      ref: data['ref'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userReference': userReference,
      'roleReference': roleReference,
      'memberReference': memberReference,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'ref': ref,
    };
  }
}