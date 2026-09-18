import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:on_demand_home_services/screens/home_screen.dart';
import 'package:on_demand_home_services/service/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Email & Password Sign In
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint("SignIn Error: $e");
      return null;
    }
  }

  // ✅ Email & Password Sign Up
  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint("SignUp Error: $e");
      return null;
    }
  }

  // ✅ Google Sign In
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential result = await _auth.signInWithCredential(credential);
        User? user = result.user;

        if (user != null) {
          Map<String, dynamic> userInfo = {
            "email": user.email,
            "name": user.displayName,
            "imgUrl": user.photoURL,
            "id": user.uid,
          };

          await DatabaseMethods().addUser(user.uid, userInfo);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  HomeScreen()),
          );
        }
      } else {
        debugPrint("Google sign-in was cancelled");
      }
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
    }
  }

  // ✅ Microsoft Sign In
  Future<void> signInWithMicrosoft(BuildContext context) async {
    try {
      final OAuthProvider microsoftProvider = OAuthProvider('microsoft.com');
      microsoftProvider.setScopes(['email', 'openid', 'profile']);

      final UserCredential userCredential =
      await _auth.signInWithProvider(microsoftProvider);
      final User? user = userCredential.user;

      if (user != null) {
        Map<String, dynamic> userInfo = {
          "email": user.email,
          "name": user.displayName,
          "imgUrl": user.photoURL,
          "id": user.uid,
        };

        await DatabaseMethods().addUser(user.uid, userInfo);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      debugPrint("Microsoft Sign-In Error: $e");
    }
  }

  // ✅ Get Current User
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  // ✅ Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    User? user = _auth.currentUser;
    return user != null;
  }


  // ✅ Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      debugPrint("SignOut Error: $e");
    }
  }
}
