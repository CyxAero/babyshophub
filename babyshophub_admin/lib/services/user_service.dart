import 'package:babyshophub_admin/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserById(String userId) async {
    _logger.i('Getting user by ID: $userId');
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _logger.i('User document found in Firestore');
        return UserModel.fromFirestore(doc);
      }
      _logger.w('User document not found in Firestore');
    } catch (e) {
      _logger.e('Error getting user by ID: $e');
    }
    return null;
  }


  Future<UserModel> createUser(
      String userId, String email, String username, bool isAdmin,
      {String? profileImage}) async {
    UserModel newUser = UserModel(
      userId: userId,
      email: email,
      username: username,
      profileImage: profileImage,
      addresses: [],
      paymentMethods: [],
      isAdmin: isAdmin,
    );

    await _firestore.collection('users').doc(userId).set(newUser.toFirestore());
    await saveUserToPreferences(newUser);
    return newUser;
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.userId)
        .update(user.toFirestore());
    await saveUserToPreferences(user);
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
    await clearUserFromPreferences();
  }

  Future<void> saveUserToPreferences(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.userId);
    await prefs.setString('email', user.email);
    await prefs.setString('username', user.username ?? '');
    await prefs.setBool('isAdmin', user.isAdmin);
  }

  Future<UserModel?> loadUserFromPreferences() async {
    _logger.i('Loading user from preferences...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    _logger.i('UserId from preferences: $userId');
    if (userId != null) {
      UserModel? user = await getUserById(userId);
      if (user != null) {
        _logger.i('User loaded successfully: ${user.userId}');
        return user;
      } else {
        _logger.w('User not found in Firestore, clearing preferences');
        await clearUserFromPreferences();
      }
    }
    _logger.i('No user loaded from preferences');
    return null;
  }

  Future<void> clearUserFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Stream<UserModel?> get userStream {
    return FirebaseAuth.instance
        .authStateChanges()
        .asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        await clearUserFromPreferences();
        return null;
      }
      UserModel? user = await getUserById(firebaseUser.uid);
      if (user != null) {
        await saveUserToPreferences(user);
      }
      return user;
    });
  }
}