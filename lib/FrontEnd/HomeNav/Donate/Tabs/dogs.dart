import 'package:anihelp/FrontEnd/Components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DogsTab extends StatefulWidget {
  @override
  _DogsTabState createState() => _DogsTabState();
}

class _DogsTabState extends State<DogsTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("dogs").snapshots(),
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
