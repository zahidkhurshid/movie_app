import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/firebase_settings.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUp(String email, String password) async {
    try {
      if (password.length < FirebaseSettings.passwordMinLength) {
        throw Exception('Password must be at least ${FirebaseSettings.passwordMinLength} characters long');
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (FirebaseSettings.emailVerificationRequired) {
        await userCredential.user!.sendEmailVerification();
      }

      await _firestore.collection(FirebaseSettings.usersCollection).doc(userCredential.user!.uid).set({
        'email': email,
        'favoriteMovies': [],
      });

      return userCredential;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (FirebaseSettings.emailVerificationRequired && !userCredential.user!.emailVerified) {
        throw Exception('Please verify your email before signing in.');
      }

      return userCredential;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> verifyEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }
}

