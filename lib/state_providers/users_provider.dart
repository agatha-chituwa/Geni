import 'package:flutter/foundation.dart';
import 'package:geni_app/model/user_model.dart';
import 'package:geni_app/repositories/user_repository.dart';

class UsersProvider with ChangeNotifier {
  final UserRepository _userRepository;
  List<User> _users = [];

  UsersProvider(this._userRepository) {
    // Load initial users from the repository
    _loadUsers();
  }

  List<User> get users => _users;

  Future<void> _loadUsers() async {
    try {
      _users = await _userRepository.getUsers().first;
      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }

  Future<void> addUser(User user) async {
    try {
      await _userRepository.addUser(user);
      _users.add(user);
      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _userRepository.updateUser(user);
      final index = _users.indexWhere((u) => u.ref == user.ref);
      if (index >= 0) {
        _users[index] = user;
        notifyListeners();
      }
    } catch (error) {
      // Handle error
    }
  }

  Future<void> deleteUser(User user) async {
    try {
      await _userRepository.deleteUser(user);
      _users.remove(user);
      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }
}