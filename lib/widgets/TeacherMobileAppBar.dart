import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/screens/Profile.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/widgets/DropDown.dart';

class TeacherMobileAppBar extends StatelessWidget {
  final int selectedIndex;
  final UserData? currentUserData;
  final ValueChanged<int> onItemTapped;
  final void Function() logOut;
  final VoidCallback? onUserDataChanged;

  const TeacherMobileAppBar({
    Key? key,
    required this.currentUserData,
    required this.logOut,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onUserDataChanged,
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
        DropDown(currentUserData: currentUserData, onUserDataChanged: onUserDataChanged,),
        Spacer(), // Pushes the following widgets to the right
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              // Open profile overlay
              showProfileOverlay(context, logOut);
            },
            child: SvgPicture.asset(currentUserData!.image), // Use user's image
          ),
        ),
        SizedBox(width: 12,)
      ],
    );
  }

  void showProfileOverlay(BuildContext context, void Function() logOut) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: SingleChildScrollView(
            child: Profile(logOut: logOut,),
          ),
        ),
      ),
    );
  }
}
