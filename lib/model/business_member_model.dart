import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geni_app/model/business_model.dart';
import 'package:geni_app/model/user_model.dart';

class BusinessMember {
  final DocumentReference userReference; // Reference to the User document
  final DocumentReference roleReference;  // Reference to the Role document
  final DocumentReference businessReference;
  final DateTime createdAt;
  final DateTime updatedAt;
  DocumentReference? ref;
  User? member;
  Business? business;

  BusinessMember({
    required this.userReference,
    required this.roleReference,
    required this.businessReference,
    required this.createdAt,
    required this.updatedAt,
    this.ref,
  });

  factory BusinessMember.fromMap(Map<String, dynamic> data) {
    return BusinessMember(
      userReference: data['userReference'] as DocumentReference,
      roleReference: data['roleReference'] as DocumentReference,
      businessReference: data['businessReference'] as DocumentReference,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      ref: data['ref'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userReference': userReference,
      'roleReference': roleReference,
      'businessReference': businessReference,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'ref': ref,
    };
  }
}