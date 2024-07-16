
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/model/business_member_model.dart';
import 'package:geni_app/model/user_model.dart';

class UserRepository {
  final DataModel _dataModel = DataModel();

  Future<void> addUser(User user) {
    user.ref = _dataModel.usersCollection.doc(user.email);
    return user.ref!.set(user.toMap());
  }

  Stream<List<User>> getUsers() {
    return _dataModel.usersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => User.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  Future<void> updateUser(User user) {
    return user.ref!.update(user.toMap());
  }

  Future<void> deleteUser(User user) {
    return user.ref!.delete();
  }

  Future<User> getUserById(String id) {
    return _dataModel.usersCollection.doc(id).get().then((doc) => User.fromMap(doc.data() as Map<String, dynamic>));
  }

  Future<User> getUserByPhone(String phone) {
    return _dataModel.usersCollection.doc(phone).get().then((doc) => User.fromMap(doc.data() as Map<String, dynamic>));
  }

  Future<List<BusinessMember>> getMembersOfBusiness(DocumentReference businessRef) async {
    final businessMembers = (await _dataModel.businessMembersCollection.where('businessReference', isEqualTo: businessRef).get())
        .docs.map((doc) => BusinessMember.fromMap(doc.data() as Map<String, dynamic>)).toList();

    for (var element in businessMembers) {
        await element.userReference.get().then((value) {
          element.member = User.fromMap(value.data() as Map<String, dynamic>);
        });
      }

    return businessMembers;

  }
}