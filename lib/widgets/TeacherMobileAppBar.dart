import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/screens/Profile.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/backend/fetchUser.dart';



import 'package:flutter/material.dart';

class TeacherMobileAppBar extends StatelessWidget {
  final int selectedIndex;
  final UserData? currentUserData;
  final ValueChanged<int> onItemTapped;
  final void Function() logOut;

  const TeacherMobileAppBar({
    Key? key,
    required this.currentUserData,
    required this.logOut,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.getColor('primary').light,
      title: Text('Your App Title'),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
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
      ],
    );
  }

  void showProfileOverlay(BuildContext context, void Function() logOut) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: SizedBox(
                height: 30,
                width: 60,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    logOut();
                    Navigator.of(context).pop();
                  },
                  child: Text('Sign Out'),
                ),
                Profile(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
