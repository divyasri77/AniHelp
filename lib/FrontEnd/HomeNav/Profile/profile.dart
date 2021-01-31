import 'package:anihelp/FrontEnd/Components/components.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firebaseCurrentUser = FirebaseAuth.instance.currentUser;
  final _textStyle = TextStyle(
      fontFamily: "Montserrat",
      letterSpacing: 2,
      color: Color(0xff1b4d3e),
      fontWeight: FontWeight.bold,
      fontSize: 22);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ProfileNameDetails(firebaseCurrentUser: _firebaseCurrentUser),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Container(
                color: Colors.grey,
                height: 1,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Row(
                children: [
                  Text("Petting History",
                      style: Components().textStyle().copyWith(
                          color: Color(0xff1b4d3e),
                          fontWeight: FontWeight.bold,
                          fontFamily: "CarterOne")),
                  Spacer(),
                  Lottie.asset("assets/41636-history.json",
                      height: 40, width: 40)
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("email", isEqualTo: _firebaseCurrentUser.email)
                    .snapshots(),
                builder: (context, userSnapshots) {
                  if (!userSnapshots.hasData)
                    return Components().circularProgressIndicator();
                  if (userSnapshots.hasError)
                    return Center(child: Icon(Icons.error));

                  return StreamBuilder<QuerySnapshot>(
                    stream: userSnapshots.data.docs.first.reference
                        .collection("history")
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (context, historySnapshots) {
                      if (!historySnapshots.hasData)
                        return Components().circularProgressIndicator();
                      if (historySnapshots.hasError)
                        return Center(child: Icon(Icons.error));

                      var history = [];
                      if (historySnapshots.hasData) {
                        for (var hist in historySnapshots.data.docs) {
                          history.add(hist.data());
                        }
                      }

                      return Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff00a86b).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemCount: 2,
                            itemBuilder: (context, index) => Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(history[index]["name"],
                                            style: _textStyle),
                                        SizedBox(height: 20),
                                        ProfileText(
                                            textStyle: _textStyle,
                                            text:
                                                "Petified: ${DateTime.now().difference(DateTime.parse(history[index]["time"].toDate().toString())).inDays.toString()} days ago"),
                                        SizedBox(height: 5),
                                        ProfileText(
                                          textStyle: _textStyle,
                                          text:
                                              "Duration: ${history[index]["duration"]}",
                                        ),
                                        SizedBox(height: 5),
                                        ProfileText(
                                          textStyle: _textStyle,
                                          text: "NGO: ${history[index]["ngo"]}",
                                        ),
                                        SizedBox(height: 5),
                                        ProfileText(
                                          textStyle: _textStyle,
                                          text: history[index]["breed"],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: history[index]["photoUrl"],
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      errorWidget: (context, url, error) {
                                        return Icon(Icons.error);
                                      },
                                      placeholder: (context, url) =>
                                          Components()
                                              .circularProgressIndicator(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            separatorBuilder: (context, _) => Divider(
                                height: 100,
                                color: Color(0xff1b4d3e),
                                thickness: 1,
                                indent: 40,
                                endIndent: 40),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileText extends StatelessWidget {
  const ProfileText({
    Key key,
    @required TextStyle textStyle,
    @required this.text,
  })  : _textStyle = textStyle,
        super(key: key);

  final TextStyle _textStyle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: 2,
        style: _textStyle.copyWith(fontSize: 14, color: Colors.grey[700]));
  }
}

class ProfileNameDetails extends StatelessWidget {
  const ProfileNameDetails({
    Key key,
    @required User firebaseCurrentUser,
  })  : _firebaseCurrentUser = firebaseCurrentUser,
        super(key: key);

  final User _firebaseCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _firebaseCurrentUser.displayName,
              style: TextStyle(
                fontFamily: "CarterOne",
                fontSize: 20,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 5),
            Text(
              _firebaseCurrentUser.email,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: _firebaseCurrentUser.photoURL,
            fit: BoxFit.contain,
            errorWidget: (context, url, error) {
              return Icon(Icons.error);
            },
            placeholder: (context, url) =>
                Components().circularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
