import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db.dart';
import '../db_helper/db_helper.dart';
import '../models/users_model.dart';

class UserProvider with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();

  List<User> _users = [];
  List<User> _acceptedUsers = [];
  List<User> _declinedUsers = [];

  List<User> get users => _users;
  List<User> get acceptedUsers => _acceptedUsers;
  List<User> get declinedUsers => _declinedUsers;

  UserProvider() {
    _loadUsersFromDB();
  }

  Future<void> _loadUsersFromDB() async {
    _acceptedUsers = await _dbHelper.fetchAcceptedUsers();
    _declinedUsers = await _dbHelper.fetchDeclinedUsers();
    _users = await _dbHelper.fetchUsers();

    // Filter the main user list to exclude already accepted or declined users
    _users = _users.where((user) =>
    !_acceptedUsers.any((acceptedUser) => acceptedUser.id == user.id) &&
        !_declinedUsers.any((declinedUser) => declinedUser.id == user.id)
    ).toList();

    notifyListeners();
  }

  Future<void> setUsers(List<User> users) async {
    await _dbHelper.clearUsers(); // Clear the table first to avoid duplicates
    for (var user in users) {
      // Only add users to the database if they're not already accepted or declined
      if (!_acceptedUsers.any((acceptedUser) => acceptedUser.id == user.id) &&
          !_declinedUsers.any((declinedUser) => declinedUser.id == user.id)) {
        await _dbHelper.insertUser(user);
      }
    }
    _users = users.where((user) =>
    !_acceptedUsers.any((acceptedUser) => acceptedUser.id == user.id) &&
        !_declinedUsers.any((declinedUser) => declinedUser.id == user.id)
    ).toList();
    notifyListeners();
  }

  Future<void> acceptUser(User user) async {
    _acceptedUsers.add(user);
    _users.removeWhere((u) => u.id == user.id);
    await _dbHelper.deleteUser(user.id);
    await _dbHelper.insertAcceptedUser(user);
    notifyListeners();
  }

  Future<void> declineUser(User user) async {
    _declinedUsers.add(user);
    _users.removeWhere((u) => u.id == user.id);
    await _dbHelper.deleteUser(user.id);
    await _dbHelper.insertDeclinedUser(user);
    notifyListeners();
  }

  // Method to clear all data on logout
  Future<void> logout() async {
    await _dbHelper.clearAllData();
    _acceptedUsers.clear();
    _declinedUsers.clear();
    _users.clear();
    notifyListeners();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();

  }
}
