import 'package:firebase_auth/firebase_auth.dart';
import 'package:firedatabasenote/pages/login_pages/sign_in_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signUpUser({name, email, password}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) await user.updateDisplayName(name);
      Logger().d(user.toString());
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Logger().w('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Logger().w('The account already exists for that email.');
      }
    } catch (e) {
      Logger().w(e);
    }
    return null;
  }

  static Future<User?> signInUser({email, password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (kDebugMode) {
        Logger().w(userCredential.user.toString());
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Logger().w('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Logger().w('The account already exists for that email.');
      }
    } catch (e) {
      Logger().w(e);
    }
    return null;
  }

  static void signOutUser(BuildContext context) async {
    await _auth.signOut().then(
        (value) => Navigator.pushReplacementNamed(context, SignInPage.id));
  }
}
