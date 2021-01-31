import 'package:anihelp/BackEnd/Auth/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff1b4d3e), Color(0xff00a86b)])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1)),
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("AniHelp",
                              style: TextStyle(
                                  fontSize: 40,
                                  letterSpacing: 2,
                                  fontFamily: "CarterOne",
                                  color: Colors.white)),
                          SizedBox(width: 20),
                          Lottie.asset("assets/19979-dog-steps.json",
                              height: 30, width: 30),
                        ],
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text(
                          "A pet away from home",
                          style: TextStyle(
                            fontFamily: "CarterOne",
                            letterSpacing: 2,
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2)),
                Lottie.asset("assets/24278-pet-lovers.json",
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width),
                Flexible(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 70),
                  child: SignInButton(Buttons.Google,
                      padding: EdgeInsets.only(left: 30.0),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      onPressed: () {
                    setState(() {
                      _isLoading = true;
                      GoogleAuth().googleLogInUser(context);
                    });
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
