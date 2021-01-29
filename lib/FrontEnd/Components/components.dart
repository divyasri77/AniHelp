import 'package:anihelp/FrontEnd/HomeNav/Donate/Book/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Components {
  Widget circularProgressIndicator() {
    return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff00a86b))));
  }

  Widget donateCards(String text, TextStyle textStyle) {
    return Expanded(
      child: Container(
        width: 100,
        child: Text(text, textAlign: TextAlign.end, style: textStyle),
      ),
    );
  }

  textStyle() {
    return TextStyle(
        color: Colors.white,
        fontFamily: "Montserrat",
        fontSize: 13,
        letterSpacing: 2,
        fontWeight: FontWeight.bold);
  }
}

class CardContent extends StatefulWidget {
  const CardContent(
      {Key key,
      @required this.documents,
      @required TextStyle textStyle,
      @required this.context})
      : _textStyle = textStyle,
        super(key: key);

  final List documents;
  final TextStyle _textStyle;
  final BuildContext context;

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
                    builder: (context) =>
                        BookingScreen(documents: widget.documents[index]))),
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
                    Hero(
                      tag: "${widget.documents[index]["name"]}",
                      child: ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: widget.documents[index]["photoUrl"],
                          placeholder: (context, url) =>
                              Components().circularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Expanded(child: SizedBox(height: 20)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Components().donateCards(
                              widget.documents[index]["name"],
                              widget._textStyle.copyWith(fontSize: 20)),
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
      {Key key, @required this.documents, @required this.context})
      : super(key: key);

  final List documents;
  final BuildContext context;

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
              textStyle: Components().textStyle(),
              context: context),
        ],
      ),
    );
  }
}
