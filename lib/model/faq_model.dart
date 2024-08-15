import 'package:cloud_firestore/cloud_firestore.dart';

class FAQ {
  final String question;
  final String answer;
  final DateTime createdAt;
  final DateTime updatedAt;
  DocumentReference? ref; // Reference to the FAQ document

  FAQ({
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
    this.ref,
  });

  factory FAQ.fromMap(Map<String, dynamic> data) {
    return FAQ(
      question: data['Question'] as String,
      answer: data['Answer'] as String,
      createdAt: (data['Created_at'] as Timestamp).toDate(),
      updatedAt: (data['Updated_at'] as Timestamp).toDate(),
      ref: data['ref'] as DocumentReference?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Question': question,
      'Answer': answer,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
      'ref': ref,
    };
  }
}