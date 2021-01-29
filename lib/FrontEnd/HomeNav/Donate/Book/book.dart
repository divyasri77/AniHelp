import 'package:anihelp/FrontEnd/Components/components.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  BookingScreen({@required this.documents});

  final documents;

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TextStyle _textStyle = TextStyle(
      fontFamily: "Montserrat",
      fontSize: 25,
      fontWeight: FontWeight.bold,
      letterSpacing: 2);

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xff00a86b),
        elevation: 10,
        title: Text("Petting ${widget.documents["name"]}",
            style: TextStyle(fontFamily: "CarterOne", letterSpacing: 2)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: "${widget.documents["name"]}",
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: widget.documents["photoUrl"],
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
                Spacer(),
                Column(
                  children: [
                    Text("${widget.documents["age"]} years old",
                        style: _textStyle),
                    SizedBox(height: 10),
                    Text(
                        "${widget.documents["city"]}, ${widget.documents["country"]}",
                        style: _textStyle.copyWith(
                            fontSize: 14, fontWeight: FontWeight.normal))
                  ],
                ),
              ],
            ),
            Expanded(child: SizedBox(height: 10)),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Select duration",
                    style: _textStyle.copyWith(fontSize: 20))),
            SizedBox(height: 20),
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
            RaisedButton(onPressed: () {})
          ],
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
              style: TextStyle(fontFamily: "Montserrat", color: Colors.white))),
    );
  }
}
