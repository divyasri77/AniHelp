import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = GoogleSignIn();

  void googleLogInUser(BuildContext context) async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googlSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      await _firebaseAuth
          .signInWithCredential(credential)
          .whenComplete(() async {
        final users = await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: googleSignInAccount.email)
            .get();

        if (users.size == 0) {
          FirebaseFirestore.instance.collection("users").add({
            'email': googleSignInAccount.email,
            'name': googleSignInAccount.displayName,
            'id': googleSignInAccount.id,
            'photoUrl': googleSignInAccount.photoUrl,
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void googleLogOutUser(BuildContext context) {
    _googlSignIn.signOut();
    _firebaseAuth.signOut();
  }
}
