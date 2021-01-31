import 'package:anihelp/FrontEnd/Components/components.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PhotosTab extends StatefulWidget {
  @override
  _PhotosTabState createState() => _PhotosTabState();
}

class _PhotosTabState extends State<PhotosTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("photos").snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) return Components().circularProgressIndicator();
        if (snapshots.hasError) return Center(child: Icon(Icons.error));

        var _photos = [];
        if (snapshots.hasData)
          for (var snap in snapshots.data.docs) _photos.add(snap.data());

        if (_photos.isEmpty)
          return Center(
            child: Text(
              "No photos found...",
              style: TextStyle(fontSize: 18, fontFamily: "Montserrat"),
            ),
          );
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FirstRow(text: "These are photos of your virtual pets"),
              SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: _photos.length,
                  separatorBuilder: (context, index) => Divider(
                      height: 30, thickness: 0, color: Colors.transparent),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: _photos[index]["photoUrl"],
                        placeholder: (context, url) =>
                            Components().circularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.4,
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