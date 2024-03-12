import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  // Collection References
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection(DataModel.usersCollectionId);
  final CollectionReference rolesCollection = FirebaseFirestore.instance.collection(DataModel.rolesCollectionId);
  final CollectionReference paymentModeCollection = FirebaseFirestore.instance.collection(DataModel.paymentModeCollectionId);
  final CollectionReference businessesCollection = FirebaseFirestore.instance.collection(DataModel.businessesCollectionId);
  final CollectionReference booksCollection = FirebaseFirestore.instance.collection(DataModel.booksCollectionId);
  final CollectionReference userBookCollection = FirebaseFirestore.instance.collection(DataModel.userBookCollectionId);
  final CollectionReference businessBookCollection = FirebaseFirestore.instance.collection(DataModel.businessBookCollectionId);
  final CollectionReference businessMembersCollection = FirebaseFirestore.instance.collection(DataModel.businessMembersCollectionId);

  CollectionReference<Object?> entriesCollection(DocumentReference bookRef) {
    return bookRef.collection(DataModel.entriesCollectionId);
  }
  
  CollectionReference<Object?> businessBookMemberCollection(DocumentReference businessBookRef) {
    return businessBookRef.collection(DataModel.businessBookMemberCollectionId);
  }

  // Collection IDs as constants
  static const String usersCollectionId = 'Users';
  static const String rolesCollectionId = 'Roles';
  static const String paymentModeCollectionId = 'PaymentMode';
  static const String businessesCollectionId = 'Businesses';
  static const String businessMembersCollectionId = 'BusinessMembers';
  static const String booksCollectionId = 'Books';
  static const String entriesCollectionId = 'Entries';
  static const String userBookCollectionId = 'UserBook';
  static const String businessBookCollectionId = 'BusinessBook';
  static const String businessBookMemberCollectionId = 'BusinessBookMember';

  // Singleton instance
  static final DataModel _instance = DataModel._internal();

  factory DataModel() {
    return _instance;
  }

  DataModel._internal();
}
