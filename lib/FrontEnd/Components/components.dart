import 'dart:io';
import 'package:anihelp/BackEnd/AddPost/add_post.dart';
import 'package:anihelp/FrontEnd/HomeNav/Donate/Book/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Components {
  Widget circularProgressIndicator() {
    return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff00a86b))));
  }

  Widget donateCards(String text, TextStyle textStyle) {
    return FittedBox(
        child: Text(text, textAlign: TextAlign.end, style: textStyle));
  }

  Widget errorSnackBar(String text) {
    return SnackBar(
      content: Text(text),
    );
  }

  TextStyle textStyle() {
    return TextStyle(
        color: Colors.white,
        fontFamily: "Montserrat",
        fontSize: 16,
        letterSpacing: 2,
        fontWeight: FontWeight.bold);
  }
}

class AlertDialogBox extends StatefulWidget {
  AlertDialogBox({@required this.scaffoldKey});

  final scaffoldKey;

  @override
  _AlertDialogBoxState createState() => _AlertDialogBoxState();
}

class _AlertDialogBoxState extends State<AlertDialogBox> {
  String title, content;
  File _image;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text("Add a new post", style: TextStyle(fontFamily: "CarterOne")),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                  hintText: "Caption is half of the post",
                  labelText: "Title",
                  labelStyle:
                      TextStyle(fontFamily: "Montserrat", color: Colors.black)),
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                  hintText: "Keep a brief content",
                  labelText: "Content",
                  labelStyle:
                      TextStyle(fontFamily: "Montserrat", color: Colors.black)),
              onChanged: (value) {
                setState(() {
                  content = value;
                });
              },
            ),
            SizedBox(height: 30),
            IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: () => _imgFromGallery()),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              child: _image == null
                  ? Center(
                      child: IconButton(
                      icon: Icon(Icons.image_not_supported),
                      onPressed: () => _imgFromGallery(),
                    ))
                  : ClipRRect(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.file(
                          _image,
                          width: MediaQuery.of(context).size.width * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      actions: [
        RaisedButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel",
              style: Components().textStyle().copyWith(fontSize: 14)),
          color: Colors.black,
        ),
        RaisedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Center(
                      child: Components().circularProgressIndicator(),
                    ),
                  );
                });
            AddPost().addPost(title, content, _image).whenComplete(() {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          },
          child: Text("Add",
              style: Components().textStyle().copyWith(fontSize: 14)),
          color: Colors.black,
        ),
      ],
    );
  }

  _imgFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}

class CardContent extends StatefulWidget {
  const CardContent(
      {Key key,
      @required this.documents,
      @required this.animalCollection,
      @required TextStyle textStyle,
      @required this.context})
      : _textStyle = textStyle,
        super(key: key);

  final List documents;
  final TextStyle _textStyle;
  final BuildContext context;
  final String animalCollection;

  @override
  _CardContentState createState() => _CardContentState();
}

class _CardContentState extends State<CardContent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) =>
            Divider(height: 40, thickness: 0, color: Colors.transparent),
        itemCount: widget.documents.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => BookingScreen(
                        document: widget.documents[index],
                        animalCollection: widget.animalCollection))),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xff00a86b).withOpacity(0.4),
                  Color(0xff00a86b)
                ]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 0.00001,
                      blurRadius: 5,
                      offset: Offset(5, 5))
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Hero(
                        tag: "${widget.documents[index]["name"]}",
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: widget.documents[index]["photoUrl"],
                            placeholder: (context, url) =>
                                Components().circularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.4,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Spacer(),
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Components().donateCards(
                                widget.documents[index]["name"],
                                widget._textStyle.copyWith(fontSize: 25)),
                            Flexible(child: SizedBox(height: 40)),
                            Components().donateCards(
                                "${widget.documents[index]["age"]} years old",
                                widget._textStyle),
                            //Flexible(child: SizedBox(height: 5)),
                            Components().donateCards(
                                widget.documents[index]["breed"],
                                widget._textStyle),
                            Components().donateCards(
                                "${widget.documents[index]["city"]}, ${widget.documents[index]["country"]}",
                                widget._textStyle),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CardContainer extends StatelessWidget {
  const CardContainer(
      {Key key,
      @required this.documents,
      @required this.context,
      @required this.animalCollection})
      : super(key: key);

  final List documents;
  final BuildContext context;
  final String animalCollection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tap on a card to see petting options",
              style: TextStyle(fontFamily: "Montserrat", fontSize: 16)),
          SizedBox(height: 20),
          CardContent(
              documents: documents,
              animalCollection: animalCollection,
              textStyle: Components().textStyle(),
              context: context),
        ],
      ),
    );
  }
}

class FirstRow extends StatelessWidget {
  const FirstRow({Key key, @required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: FittedBox(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 18,
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        Icon(Icons.arrow_downward)
      ],
    );
  }
}
