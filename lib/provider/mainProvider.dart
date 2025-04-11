import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User? user;
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      user = userCredential.user;
      if (user != null) {
        await _saveUserDataToFirestore(user!);
      }
      notifyListeners();
    } catch (e) {
      // Handle errors here
      print("Error during Google Sign-In: $e");
    }
  }

  Future<void> _saveUserDataToFirestore(User user) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.email);

    final userSnapshot = await userDoc.get();
    if (!userSnapshot.exists) {
      await userDoc.set({
        'name': user.displayName ?? '',
        "img": user.photoURL ?? '',
        'scoreVocabulary': [],
        "scoreSpeaking": [],
        "scorePronunciation": [],
      });
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
    user = null;
    notifyListeners();
  }
}
