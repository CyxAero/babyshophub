import 'package:babyshophub_user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Logger _logger = Logger();

  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        UserModel userModel = UserModel.fromFirestore(doc);
        await saveUserToPreferences(userModel); // Save user to preferences
        return userModel;
      }
      return null;
    } catch (e) {
      _logger.e("Error signing in with email and password: $e");
      return null;
    }
  }

  Future<UserModel?> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
    bool isAdmin,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
          'profileImage': '',
          'addresses': [],
          'paymentMethods': [],
          'isAdmin': isAdmin,
        });

        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        UserModel userModel = UserModel.fromFirestore(doc);
        await saveUserToPreferences(userModel); // Save user to preferences
        return userModel;
      }
      return null;
    } catch (e) {
      _logger.e("Error registering with email and password: $e");
      return null;
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    _logger.d('signInWithGoogle: Start');

    try {
      _logger.d('signInWithGoogle: Initiating Google sign-in');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _logger.w('signInWithGoogle: Google Sign-In canceled by user');
        return null;
      }

      _logger.d('signInWithGoogle: Google Sign-In successful');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      _logger.d('signInWithGoogle: Signing in with Google credentials');
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (result.additionalUserInfo?.isNewUser ?? false) {
        _logger.d(
            'signInWithGoogle: New Google user, creating Firestore document');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .set({
          'email': user?.email,
          'username':
              googleUser.displayName ?? '', // Save username from Google account
          'profileImage': user?.photoURL,
          'addresses': [],
          'paymentMethods': [],
          'isAdmin': false,
        });
      }

      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        UserModel userModel = UserModel.fromFirestore(doc);
        await saveUserToPreferences(userModel); // Save user to preferences
        return userModel;
      }
      return null;
    } catch (e, stacktrace) {
      _logger.e('Error in signInWithGoogle: $e\n$stacktrace');
      return null;
    }
  }

  // In AuthService class:
  Future<void> saveUserToPreferences(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.userId);
    await prefs.setString('email', user.email);
    await prefs.setString('name', user.name);
    await prefs.setString('username', user.username ?? '');
    // Add other user properties as needed
  }

  Future<UserModel?> loadUserFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? email = prefs.getString('email');
    String? name = prefs.getString('name');
    String? username = prefs.getString('username');
    // Load other user properties as needed

    if (userId != null && email != null && name != null) {
      return UserModel(
        userId: userId,
        email: email,
        name: name,
        username: username,
        isAdmin: false, // or load the correct value
      );
    }
    return null;
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      _logger.e("Error resetting password: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      _logger.e("Error signing out: $e");
    }
  }

  Future<void> deleteUser(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .delete();
      await _auth.currentUser?.delete();
    } catch (e) {
      _logger.e("Error deleting user: $e");
    }
  }

  // Method to get current user
  Future<UserModel?> currentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return UserModel.fromFirestore(doc);
    }
    return null;
  }
}
