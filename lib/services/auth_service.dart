import 'package:arlex_getx/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential authResult =
          await FirebaseService.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return authResult.user;
    } catch (error) {
      rethrow;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential authResult =
          await FirebaseService.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return authResult.user;
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == "email-already-in-use") {
          throw ("Email already in use.");
        } else {
          throw ("Something went wrong.");
        }
      } else {
        throw ("Something went wrong.");
      }
    }
  }

  Future<void> saveUserDetails({
    required String name,
    required String uid,
  }) async {
    try {
      await FirebaseService.firestore
          .collection("Users")
          .doc(uid)
          .set({'name': name});
    } catch (e) {
      rethrow;
    }
  }

  bool checkLoginStatus() {
    if (FirebaseService.auth.currentUser != null) {
      return true;
    }
    return false;
  }
}
