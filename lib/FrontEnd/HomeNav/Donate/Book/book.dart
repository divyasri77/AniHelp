import 'package:anihelp/BackEnd/Petting/petting_function.dart';
import 'package:anihelp/FrontEnd/Components/components.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class BookingScreen extends StatefulWidget {
  BookingScreen({@required this.document, @required this.animalCollection});
  final document;
  final String animalCollection;

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TextStyle _textStyle = TextStyle(
      fontFamily: "Montserrat",
      fontSize: 25,
      fontWeight: FontWeight.bold,
      letterSpacing: 2);

  int _selectedIndex = 6;
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: Components().circularProgressIndicator(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Color(0xff00a86b),
          elevation: 10,
          title: Text("Petting ${widget.document["name"]}",
              style: TextStyle(fontFamily: "CarterOne", letterSpacing: 2)),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0xff00a86b).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Hero(
                        tag: "${widget.document["name"]}",
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: widget.document["photoUrl"],
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
                    Flexible(flex: 1, child: SizedBox(width: 40)),
                    Flexible(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            child: Text("${widget.document["age"]} years old",
                                style: _textStyle),
                          ),
                          SizedBox(height: 10),
                          FittedBox(
                              child: Text("${widget.document["gender"]}",
                                  style: _textStyle.copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal))),
                          FittedBox(
                              child: Text("${widget.document["breed"]}",
                                  style: _textStyle.copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal))),
                          FittedBox(
                              child: Text(
                                  "${widget.document["city"]}, ${widget.document["country"]}",
                                  style: _textStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox(height: 10)),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Select duration",
                      style: _textStyle.copyWith(fontSize: 20))),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 6;
                        });
                      },
                      child: durationButtons(6, _selectedIndex)),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 12;
                        });
                      },
                      child: durationButtons(12, _selectedIndex)),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 24;
                        });
                      },
                      child: durationButtons(24, _selectedIndex)),
                ],
              ),
              SizedBox(height: 10),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 100;
                    });
                  },
                  child: durationButtons(100, _selectedIndex)),
              Expanded(child: SizedBox(height: 10)),
              RaisedButton(
                child: Text("Start petting",
                    style: _textStyle.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                elevation: 0,
                color: Color(0xff00a86b),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  final String duration =
                      BookFunctions().durationToString(_selectedIndex);

                  await Petting()
                      .pettingFunction(context, widget.document, duration, widget.animalCollection)
                      .whenComplete(() {
                    final _snackbar = SnackBar(
                      content: Text("Successfully Petified!",
                          style: _textStyle.copyWith(
                              fontFamily: "CarterOne",
                              fontSize: 14,
                              color: Color(0xff00a86b))),
                      backgroundColor: Colors.white,
                      duration: Duration(seconds: 1),
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    //Navigator.pop(context);
                    _scaffoldKey.currentState
                        .showSnackBar(_snackbar)
                        .closed
                        .then((value) => Navigator.pop(context));
                  });
                },
              ),
              Expanded(child: SizedBox(height: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget durationButtons(int month, int selectedIndex) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: month == selectedIndex
            ? Color(0xff00a86b)
            : Color(0xff00a86b).withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
          child: Text(month == 100 ? "Lifetime" : "$month Month",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: month == selectedIndex
                      ? Colors.white
                      : Color(0xff1b4d3e)))),
    );
  }
}

class BookFunctions {
  String durationToString(int selectedIndex) {
    String _duration = "";
    switch (selectedIndex) {
      case 6:
        _duration = "6 months";
        break;
      case 12:
        _duration = "1 year";
        break;
      case 24:
        _duration = "2 years";
        break;
      case 100:
        _duration = "permanently";
        break;
      default:
        _duration = "6 months";
        break;
    }
    return _duration;
  }
}
