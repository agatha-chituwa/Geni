import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/model/user_model.dart';

class UserRepository {
  final DataModel _dataModel = DataModel();

  Future<void> addUser(User user) {
    user.ref = _dataModel.usersCollection.doc(user.phone);
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
}