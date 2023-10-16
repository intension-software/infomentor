import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/screens/Profile.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/widgets/ReWidgets.dart';


class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function() logOut;
  final FetchResult? capitol;
  final UserData? currentUserData;
  final Function(int) onNavigationItemSelected;
   final void Function() tutorial;

  const MobileAppBar({
    Key? key,
    required this.onNavigationItemSelected,
    required this.logOut,
    required this.capitol,
    required this.currentUserData,
    required this.tutorial
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);


  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).primaryColor, // Set the appbar background color
        elevation: 0,
        flexibleSpace:  currentUserData != null && capitol != null ? SafeArea(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 8),
                    Spacer(),
                    Text(
                        '${currentUserData!.points}/135',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    SizedBox(width: 8),
                    SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                    SizedBox(width: 12),
                     IconButton(
                      icon: SvgPicture.asset('assets/icons/bellWhiteIcon.svg'),
                      onPressed: () => 
                        onNavigationItemSelected(4),
                    ),
                    SizedBox(width: 12),
                     IconButton(
                            icon: SvgPicture.asset('assets/icons/infoIcon.svg'),
                            onPressed: () {
                              tutorial();
                            },
                          ),
                    SizedBox(width: 12),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                      onTap: () {
                        // Open profile overlay
                        onNavigationItemSelected(5);
                      },
                        child: CircularAvatar(name: currentUserData!.name, width: 16, fontSize: 16,), // Use user's image
                    ),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              )
        ) : Container(),
      );
  }
}
  