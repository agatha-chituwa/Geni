import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  // Collection References
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
  final CollectionReference rolesCollection = FirebaseFirestore.instance.collection('Roles');
  final CollectionReference paymentModeCollection = FirebaseFirestore.instance.collection('PaymentMode');
  final CollectionReference businessMembersCollection = FirebaseFirestore.instance.collection('BusinessMembers');
  final CollectionReference businessesCollection = FirebaseFirestore.instance.collection('Businesses');
  CollectionReference<Object?> booksCollection(DocumentReference businessRef) {
    return businessRef.collection('Books');
  }
  CollectionReference<Object?> entriesCollection(DocumentReference bookRef) {
    return bookRef.collection('Entries');
  }
  CollectionReference<Object?> bookMemberCollection(DocumentReference businessRef) {
    return businessRef.collection('BookMembers');
  }

  // Collection IDs as constants
  static const String usersCollectionId = 'Users';
  static const String rolesCollectionId = 'Roles';
  static const String paymentModeCollectionId = 'PaymentMode';
  static const String businessMembersCollectionId = 'BusinessMembers';
  static const String businessesCollectionId = 'Businesses';
  static const String booksCollectionId = 'Books';
  static const String entriesCollectionId = 'Entries';
  static const String bookMembersCollectionId = 'BookMembers';

  // Singleton instance
  static final DataModel _instance = DataModel._internal();

  factory DataModel() {
    return _instance;
  }

  DataModel._internal();
}
