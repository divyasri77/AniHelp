import 'package:anihelp/FrontEnd/Components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BirdsTab extends StatefulWidget {
  @override
  _BirdsTabState createState() => _BirdsTabState();
}

class _BirdsTabState extends State<BirdsTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("birds").snapshots(),
      builder: (context, snapshots) {
        var documents = [];
        if (!snapshots.hasData) return Components().circularProgressIndicator();

        if (snapshots.hasData) {
          for (var snap in snapshots.data.docs) {
            documents.add(snap.data());
          }
        }
        return CardContainer(documents: documents, context: context);
      },
    );
  }
}
