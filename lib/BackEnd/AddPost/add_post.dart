import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddPost {
  Future addPost(String title, String description, File image) async {
    final _currentUser = FirebaseAuth.instance.currentUser;
    if (image == null) {
      await FirebaseFirestore.instance.collection("posts").add({
        "title": title,
        "description": description,
        "createdAt": FieldValue.serverTimestamp(),
        "email": _currentUser.email,
        "name": _currentUser.displayName
      });
    } else {
      String fileName = basename(image.path);
      String downloadLink;
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(image).whenComplete(() async {
        downloadLink = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection("posts").add({
          "title": title,
          "description": description,
          "photoUrl": downloadLink,
          "createdAt": FieldValue.serverTimestamp(),
          "email": _currentUser.email,
          "name": _currentUser.displayName
        });
      });
    }
  }
}
