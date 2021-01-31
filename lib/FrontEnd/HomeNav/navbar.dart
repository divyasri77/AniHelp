import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'Donate/donate.dart';
import 'Profile//profile.dart';
import 'Posts/posts.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
  double gap = 10;
  List body = [DonateScreen(), PostsScreen(), ProfileScreen()];
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView.builder(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _selectedIndex = page;
            });
          },
          itemCount: 3,
          itemBuilder: (context, position) {
            return Scaffold(
              body: body[position],
            );
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                  spreadRadius: -10,
                  blurRadius: 60,
                  offset: Offset(0, 25),
                  color: Colors.black.withOpacity(0.4))
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(3),
            child: GNav(
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 900),
              tabs: [
                navBarButtons(Icons.pets, "Petify", Color(0xff00a86b)),
                navBarButtons(Icons.post_add, "Posts", Color(0xff00a86b)),
                navBarButtons(Icons.person, "Me", Color(0xff00a86b)),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                _pageController.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }

  navBarButtons(IconData iconData, String text, Color backgroundColor) {
    return GButton(
      icon: iconData,
      iconColor: Colors.black,
      iconActiveColor: Color(0xff1b4d3e),
      text: text,
      textStyle: TextStyle(
          fontFamily: 'CarterOne',
          letterSpacing: 1.5),
      backgroundColor: backgroundColor.withOpacity(0.3),
      iconSize: 24,
      padding: padding,
      gap: gap,

    );
  }
}
