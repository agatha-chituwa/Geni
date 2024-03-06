import 'package:geni_app/database/data_model.dart';
import 'package:geni_app/model/user_model.dart';

class UserRepository {
  final DataModel _dataModel = DataModel();

  Future<void> addUser(User user) {
    final ref = _dataModel.usersCollection.doc();
    user.id = ref.id;
    return ref.set(user.toMap());
  }

  Stream<List<User>> getUsers() {
    return _dataModel.usersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => User.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  Future<void> updateUser(User user) {
    return _dataModel.usersCollection.doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String id) {
    return _dataModel.usersCollection.doc(id).delete();
  }

  Future<User> getUser(String id) {
    return _dataModel.usersCollection.doc(id).get().then((doc) => User.fromMap(doc.data() as Map<String, dynamic>));
  }

  
}