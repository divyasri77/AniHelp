import 'package:anihelp/FrontEnd/Components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Petting {
  Future pettingFunction(BuildContext context, var document, String duration,
      String animalCollection) async {
    await uploadHistory(context, document, duration, animalCollection)
        .whenComplete(() async => await sendMail(context, document, duration));
  }

  Future uploadHistory(BuildContext context, var document, String duration,
      String animalCollection) async {
    try {
      final users = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: FirebaseAuth.instance.currentUser.email)
          .get();
      for (var user in users.docs) {
        user.reference.collection("history").add({
          "time": FieldValue.serverTimestamp(),
          "uuid": document["uuid"],
          "duration": duration,
          "type": animalCollection,
          "name": document["name"],
          "breed": document["breed"],
          "ngo": document["ngo"],
          "photoUrl": document["photoUrl"]
        });
      }
    } catch (exception) {
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(
          Components().errorSnackBar("Error uploading to database"));
      print(exception);
    }
  }

  Future sendMail(BuildContext context, var document, String duration) async {
    String _email = env["email"];
    String _password = env["password"];

    // ignore: deprecated_member_use
    final smtpServer = gmail(_email, _password);

    final message = Message()
      ..from = Address(_email, 'AniHelp')
      ..recipients.add('${FirebaseAuth.instance.currentUser.email}')
      ..subject = 'AniHelp Petting Receipt'
      ..html =
          "<h1>Thank you for petting ${document["name"]}</h1>\n<p>You have successfully adopted ${document["gender"] == "Male" ? "him" : "her"} for $duration</p>\n<p>Your concerned NGO is ${document["ngo"]} and you may contact them for further details</p>\n<p>NGO email - ${document["ngo_email"]}</p>\n<p>Please pay \$27.454 to the respective NGO strictly on monthly basis for $duration</p>\n<p>The NGO will provide you with live videos and status of your pet every week. For issues, you may post in our issues section.</p>";

    try {
      await send(message, smtpServer).whenComplete(() {
        print('Message sent');
      });
    } on MailerException catch (e) {
      Scaffold.of(context)
          .showSnackBar(Components().errorSnackBar("Error sending mail"));
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      Navigator.pop(context);
    }
  }
}
