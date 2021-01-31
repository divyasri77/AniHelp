import 'package:anihelp/FrontEnd/Components/components.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _textStyle = TextStyle(
      fontFamily: "Montserrat",
      letterSpacing: 2,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 22);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Color(0xff00a86b),
          actions: [
            Center(
                child: Text("Add Post",
                    style: _textStyle.copyWith(
                        fontSize: 16, fontFamily: "CarterOne"))),
            SizedBox(width: 20),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: CircleAvatar(
                backgroundColor: Colors.transparent.withOpacity(0.2),
                child: IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialogBox(scaffoldKey: _scaffoldKey);
                        });
                  },
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy("createdAt", descending: true)
                .snapshots(),
            builder: (context, snapshots) {
              if (!snapshots.hasData)
                return Components().circularProgressIndicator();
              if (snapshots.hasError) return Center(child: Icon(Icons.error));

              var posts = [];
              if (snapshots.hasData) {
                for (var snap in snapshots.data.docs) posts.add(snap.data());
              }

              if (posts.isEmpty) return Center(child: Text("No data found"));

              return ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: posts.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 70, thickness: 0, color: Color(0xff00a86b)),
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            posts[index]["photoUrl"] == null
                                ? Center(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                        child: Lottie.asset(
                                            "assets/70-image-icon-tadah.json"),
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    child: CachedNetworkImage(
                                      imageUrl: posts[index]["photoUrl"],
                                      placeholder: (context, url) =>
                                          Components()
                                              .circularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 10),
                                  Text(posts[index]["title"],
                                      textAlign: TextAlign.end,
                                      maxLines: 3,
                                      style: _textStyle),
                                  SizedBox(height: 20),
                                  Text(posts[index]["description"],
                                      textAlign: TextAlign.end,
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                      style: _textStyle.copyWith(
                                          fontSize: 14, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1),
                          child: Row(
                            children: [
                              Text(
                                "Posted ${DateTime.now().difference(DateTime.parse(posts[index]["createdAt"].toDate().toString())).inDays.toString()} days ago",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.grey[700],
                                    fontStyle: FontStyle.italic),
                              ),
                              Spacer(),
                              Text(
                                posts[index]["name"],
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.grey[700],
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
