import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  final List<User> _favoriteUsers = [];

  List<User> get users => _users;
  List<User> get favoriteUsers => _favoriteUsers;

  void setUsers(List<User> userList) {
    _users = userList;
    notifyListeners();
  }

  void addUser (User user) {
    _users.add(user);
    notifyListeners();
  }

  void updateUser (User updatedUser ) {
    final index = _users.indexWhere((u) => u.id == updatedUser .id);
    if (index != -1) {
      _users[index] = updatedUser ;
      notifyListeners();
    }
  }

  void deleteUser (String userId) {
    _users.removeWhere((u) => u.id == userId);
    _favoriteUsers.removeWhere((u) => u.id == userId);
    notifyListeners();
  }

  void toggleFavorite(User user) {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      final updatedUser  = _users[index].copyWith(isFavorite: !_users[index].isFavorite);
      _users[index] = updatedUser ;

      if (updatedUser .isFavorite) {
        if (!_favoriteUsers.contains(updatedUser )) {
          _favoriteUsers.add(updatedUser );
        }
      } else {
        _favoriteUsers.removeWhere((u) => u.id == updatedUser .id);
      }
      notifyListeners();
    }
  }
}