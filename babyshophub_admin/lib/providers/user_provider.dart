import 'package:babyshophub_admin/models/user_model.dart';
import 'package:babyshophub_admin/services/auth_service.dart';
import 'package:babyshophub_admin/services/user_service.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  UserModel? get user => _user;

  // UserProvider() {
  //   initUser();
  // }

  Future<void> initUser() async {
    _user = await _userService.loadUserFromPreferences();
    notifyListeners();
    _authService.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser == null) {
        _user = null;
      } else {
        _user = await _userService.getUserById(firebaseUser.uid);
      }
      notifyListeners();
    });
  }

  Future<void> refreshUser() async {
    if (_user != null) {
      _user = await _userService.getUserById(_user!.userId);
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}