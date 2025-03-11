import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geni_app/model/user_book_model.dart';

class Book {
  String name;
  String description;
  final DateTime createdAt;
  DateTime updatedAt;
  DocumentReference? ref;
  List<UserBook> members = [];
  double balance = 0;
  double totalCashIn = 0;
  double totalCashOut = 0;

  Book({
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.ref,
    this.balance = 0,
    this.totalCashIn = 0,
    this.totalCashOut = 0,
  });

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(
      name: data['Name'] as String,
      description: data['Description'] as String,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      balance: data['Balance'] as double,
      totalCashIn: data['total_cash_in'] as double? ?? 0.0,
      totalCashOut: data['total_cash_out'] as double? ?? 0.0,
      ref: data['ref'] as DocumentReference?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Description': description,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'Balance': balance,
      'total_cash_in': totalCashIn,
      'total_cash_out': totalCashOut,
      'ref': ref,
    };
  }
}