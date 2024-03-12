import 'package:cloud_firestore/cloud_firestore.dart';

class Entry {
  final double amount;
  final String description;
  final DocumentReference bookMemberRef; // Reference to the BookMember document
  final DocumentReference paymentModeRef;  // Reference to the PaymentMode document
  final DateTime createdAt;
  final DateTime updatedAt;
  DocumentReference? ref; // Reference to the Entry document

  Entry({
    required this.amount,
    required this.description,
    required this.bookMemberRef,
    required this.paymentModeRef,
    required this.createdAt,
    required this.updatedAt,
    required this.ref,
  });

  factory Entry.fromMap(Map<String, dynamic> data) {
    return Entry(
      amount: data['Amount'] as double,
      description: data['Description'] as String,
      bookMemberRef: data['bookMemberRef'] as DocumentReference,
      paymentModeRef: data['paymentModeRef'] as DocumentReference,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      ref: data['ref'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Amount': amount,
      'Description': description,
      'bookMemberRef': bookMemberRef,
      'paymentModeRef': paymentModeRef,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'ref': ref,
    };
  }
}