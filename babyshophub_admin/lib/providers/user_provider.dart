import 'package:babyshophub_admin/models/user_model.dart';
import 'package:babyshophub_admin/services/auth_service.dart';
import 'package:babyshophub_admin/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class UserProvider with ChangeNotifier {
  final Logger _logger = Logger();

  UserModel? _user;
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  bool _isInitialized = false;

  UserModel? get user => _user;

  Future<void> initUser() async {
    if (_isInitialized) return;
    _logger.i('Initializing user...');

    try {
      // First, try to load user from preferences
      _user = await _userService.loadUserFromPreferences();
      _logger.i('User loaded from preferences: ${_user?.userId}');

      // Set up the auth state listener
      _authService.authStateChanges.listen(_handleAuthStateChange);

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _logger.e('Error in initUser: $e');
      _user = null;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _handleAuthStateChange(User? firebaseUser) async {
    _logger.i('Auth state changed. FirebaseUser: ${firebaseUser?.uid}');
    if (firebaseUser == null) {
      if (_user != null) {
        _user = null;
        _logger.i('User set to null due to Firebase auth state');
        notifyListeners();
      }
    } else {
      if (_user == null || _user!.userId != firebaseUser.uid) {
        _user = await _userService.getUserById(firebaseUser.uid);
        _logger.i('User loaded from Firestore: ${_user?.userId}');
        notifyListeners();
      }
    }
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