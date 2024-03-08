import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessBookMember {
  final DocumentReference businessMemberRef; // Reference to the User document through BusinessMember collection
  final DocumentReference roleRef;  // Reference to the Role document
  final DateTime createdAt;
  final DateTime updatedAt;
  final DocumentReference ref; // Reference to the BusinessBookMember document itself

  BusinessBookMember({
    required this.businessMemberRef,
    required this.roleRef,
    required this.createdAt,
    required this.updatedAt,
    required this.ref,
  });

  factory BusinessBookMember.fromMap(Map<String, dynamic> data) {
    return BusinessBookMember(
      businessMemberRef: data['businessMemberRef'] as DocumentReference,
      roleRef: data['roleRef'] as DocumentReference,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      ref: data['ref'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businessMemberRef': businessMemberRef,
      'roleRef': roleRef,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'ref': ref,
    };
  }
}