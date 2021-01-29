import 'package:anihelp/FrontEnd/HomeNav/navbar.dart';
import 'package:anihelp/FrontEnd/Welcome/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData)
            return NavBar();
          else
            return WelcomeScreen();
        });
  }
}