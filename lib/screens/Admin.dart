import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/UserForm.dart';
import 'package:infomentor/backend/fetchUser.dart';

class Admin extends StatefulWidget {
  final UserData? currentUserData;


  Admin({
    Key? key,
    required this.currentUserData,
  }) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageView(
    controller: _pageController,
    onPageChanged: _onPageChanged,
      children: [
        Column(
          children: [
            Container(
            width: 900,
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: AppColors.mono.darkGrey,
                ),
                onPressed: () => 
                  _onNavigationItemSelected(1),
              ),
          ),
          UserForm(currentUserData: widget.currentUserData,)
          ],
        ),
        Column(
          children: [
            Container(
            width: 900,
            alignment: Alignment.topLeft,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.mono.darkGrey,
                ),
                onPressed: () => 
                  _onNavigationItemSelected(0),
              ),
          ),
          ],
        )
      ]
    );
  }
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
  
}