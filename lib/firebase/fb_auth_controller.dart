import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:vp12_firebase/models/fb_response.dart';

typedef UserStateCallback = void Function({required bool loggedIn});

class FbAuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //SignIn
  Future<FbResponse> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        String message = userCredential.user!.emailVerified
            ? 'Logged in successfully'
            : 'You must verify your email!';
        return FbResponse(
            message: message, status: userCredential.user!.emailVerified);
      }
    } on FirebaseAuthException catch (e) {
      return _controlFirebaseException(e);
    } catch (e) {
      //
    }
    return FbResponse(message: 'Something went wrong', status: false);
  }

  //CreateAccount
  Future<FbResponse> createAccount(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
        return FbResponse(
          message:
              'Account created successfully, check your email & verify account',
          status: true,
        );
      }
    } on FirebaseAuthException catch (e) {
      return _controlFirebaseException(e);
    } catch (e) {
      //
    }
    return FbResponse(message: 'Something went wrong', status: false);
  }

  //Logout
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  //NOT FOR USE - SHOULD NOT USED
  bool get loggedIn => _firebaseAuth.currentUser != null;

  StreamSubscription checkUserStatus(UserStateCallback userStateCallback) {
    return _firebaseAuth.authStateChanges().listen((User? user) {
      userStateCallback(loggedIn: user != null);
    });
  }

  //ForgetPassword
  Future<FbResponse> forgetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return FbResponse(
          message: 'Password reset email sent successfully', status: true);
    } on FirebaseAuthException catch (e) {
      return _controlFirebaseException(e);
    } catch (e) {
      //
    }
    return FbResponse(message: 'Something went wrong', status: false);
  }

  FbResponse _controlFirebaseException(FirebaseAuthException exception) {
    print('Message: ${exception.message}');
    if (exception.code == 'email-already-in-use') {
      //
    } else if (exception.code == 'invalid-email') {
      //
    } else if (exception.code == 'operation-not-allowed') {
      //
    } else if (exception.code == 'weak-password') {
      //
    } else if (exception.code == 'user-disabled') {
      //
    } else if (exception.code == 'user-not-found') {
      //
    } else if (exception.code == 'wrong-password') {
      //
    } else if (exception.code == 'auth/invalid-email') {
      //
    } else if (exception.code == 'auth/user-not-found') {
      //
    }
    return FbResponse(
        message: exception.message ?? 'Error occurred', status: false);
  }
}
