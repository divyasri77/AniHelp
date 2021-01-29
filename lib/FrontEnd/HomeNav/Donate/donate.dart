import 'package:flutter/material.dart';
import 'Tabs/birds.dart';
import 'Tabs/cats.dart';
import 'Tabs/dogs.dart';

class DonateScreen extends StatefulWidget {
  @override
  _DonateScreenState createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
                backgroundColor: Color(0xff00a86b),
                elevation: 10,
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                  tabs: [
                    Tab(text: "Dogs"),
                    Tab(text: "Cats"),
                    Tab(text: "Birds")
                  ],
                )),
          ),
          body: TabBarView(
            children: [
              DogsTab(),
              CatsTab(),
              BirdsTab()
            ],
          ),
        ),
      ),
    );
  }
}
