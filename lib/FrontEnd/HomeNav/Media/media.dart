import 'package:anihelp/FrontEnd/HomeNav/Media/Tabs/photos.dart';
import 'package:anihelp/FrontEnd/HomeNav/Media/Tabs/videos.dart';
import 'package:flutter/material.dart';

class MediaScreen extends StatefulWidget {
  @override
  _MediaScreenState createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
              backgroundColor: Color(0xff00a86b),
              actions: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      "Straight from the NGO",
                      style: TextStyle(
                          fontFamily: "CarterOne",
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: 2),
                    ),
                  ),
                )
              ],
              elevation: 10,
              bottom: TabBar(
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: TextStyle(
                    fontFamily: "CarterOne",
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3),
                tabs: [
                  Tab(text: "Photos"),
                  Tab(text: "Videos"),
                ],
              )),
          body: TabBarView(
            children: [
              PhotosTab(),
              VideosTab(),
            ],
          ),
        ),
      ),
    );
  }
}
