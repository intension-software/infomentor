import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/screens/Profile.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/backend/userController.dart';
import 'package:infomentor/widgets/DropDown.dart';

class TeacherMobileAppBar extends StatelessWidget {
  final int selectedIndex;
  final UserData? currentUserData;
  final ValueChanged<int> onItemTapped;
  final void Function() logOut;
  final VoidCallback? onUserDataChanged;
  final void Function() tutorial;
  final void Function(int) onNavigationItemSelected;


  const TeacherMobileAppBar({
    Key? key,
    required this.currentUserData,
    required this.logOut,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onUserDataChanged,
    required this.tutorial,
    required this.onNavigationItemSelected
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.getColor('primary').light,
      
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
        Spacer(), // Pushes the following widgets to the middle
        Container(
          height: 20,
          child: DropDown(currentUserData: currentUserData, onUserDataChanged: onUserDataChanged,),
        ),
        SizedBox(width:90 ,),
        IconButton(
        icon: SvgPicture.asset('assets/icons/infoIcon.svg', color: Colors.white,),
        onPressed: () {
          tutorial();
        },
      ),
      SizedBox(width: 8),
        IconButton(
        icon: SvgPicture.asset('assets/icons/bellWhiteIcon.svg'),
        onPressed: () => 
          onNavigationItemSelected(5),
      ),
      SizedBox(width: 10,)
      ],
    );
  }

}
