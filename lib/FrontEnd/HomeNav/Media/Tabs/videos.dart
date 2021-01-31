import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:anihelp/FrontEnd/Components/components.dart';

class VideosTab extends StatefulWidget {
  @override
  _VideosTabState createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("videos").snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) return Components().circularProgressIndicator();
        if (snapshots.hasError) return Center(child: Icon(Icons.error));

        var _videos = [];
        if (snapshots.hasData)
          for (var snap in snapshots.data.docs) _videos.add(snap.data());

        if (_videos.isEmpty)
          return Center(
            child: Text(
              "No videos found...",
              style: TextStyle(fontSize: 18, fontFamily: "Montserrat"),
            ),
          );
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FirstRow(text: "These are videos of your virtual pets"),
              SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: _videos.length,
                  separatorBuilder: (context, index) => Divider(
                      height: 30, thickness: 0, color: Colors.transparent),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: BetterPlayer.network(
                          _videos[index]["photoUrl"],
                          betterPlayerConfiguration: BetterPlayerConfiguration(
                            aspectRatio: 16 / 9,
                          ),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}