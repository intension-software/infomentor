import 'package:flutter/material.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/screens/Login.dart';
import 'package:infomentor/screens/Learning.dart';
import 'package:infomentor/screens/Challenges.dart';
import 'package:infomentor/screens/Discussions.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: reBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          Container(
            child: Text('home'),
          ), // Replace with your actual widget for the Home page
          Challenges(),
          Discussions(),
          Learning(),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
