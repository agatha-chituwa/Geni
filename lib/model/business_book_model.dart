import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geni_app/model/book_model.dart';

class BusinessBook {
  final DocumentReference businessReference; // Reference to the Business document
  final DocumentReference bookReference; // Reference to the Book document
  final DateTime createdAt;
  final DateTime updatedAt;
  DocumentReference? ref; // Reference to the BusinessBook document itself
  Book? book;

  BusinessBook({
    required this.businessReference,
    required this.bookReference,
    required this.createdAt,
    required this.updatedAt,
    required this.ref,
  });

  factory BusinessBook.fromMap(Map<String, dynamic> data) {
    return BusinessBook(
      businessReference: data['businessReference'] as DocumentReference,
      bookReference: data['bookReference'] as DocumentReference,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      ref: data['ref'] as DocumentReference,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'businessReference': businessReference,
      'bookReference': bookReference,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'ref': ref,
    };
  }
}
