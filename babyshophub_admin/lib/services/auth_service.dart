import 'package:babyshophub_admin/models/user_model.dart';
import 'package:babyshophub_admin/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Logger _logger = Logger();
  final UserService _userService = UserService();

  // Future<UserModel?> signInWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     UserCredential result = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return await _userService.getUserById(result.user!.uid);
  //   } catch (e) {
  //     _logger.e("Error signing in with email and password: $e");
  //     return null;
  //   }
  // }

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      _logger.i('Attempting to sign in with email: $email');
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.i('Sign in successful for user: ${result.user?.uid}');
      return await _userService.getUserById(result.user!.uid);
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
      return await _userService.createUser(
        result.user!.uid,
        email,
        username,
        isAdmin,
      );
    } catch (e) {
      _logger.e("Error registering with email and password: $e");
      return null;
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

      if (result.additionalUserInfo?.isNewUser ?? false) {
        return await _userService.createUser(
          result.user!.uid,
          result.user!.email!,
          googleUser.displayName ?? '',
          true, // Set isAdmin as needed
          profileImage: result.user!.photoURL,
        );
      } else {
        return await _userService.getUserById(result.user!.uid);
      }
    } catch (e) {
      _logger.e('Error in signInWithGoogle: $e');
      return null;
    }
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

  Future<void> deleteUser() async {
    try {
      await _userService.deleteUser(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } catch (e) {
      _logger.e("Error deleting user: $e");
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
