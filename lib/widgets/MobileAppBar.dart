import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/screens/Profile.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';


class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final FetchResult? capitol;
  final UserData? currentUserData;
  final int? capitolLength;

  const MobileAppBar({
    Key? key,
    required this.capitol,
    required this.currentUserData,
    required this.capitolLength,
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
                        '${currentUserData!.points}/${capitolLength ?? 0}',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: AppColors.yellow.light,
                            ),
                      ),
                    SizedBox(width: 4),
                    SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                    SizedBox(width: 8),
                     SvgPicture.asset('assets/icons/bellWhiteIcon.svg'),
                    SizedBox(width: 8),

                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                      onTap: () {
                        // Open profile overlay
                        showProfileOverlay(context);
                      },
                        child: SvgPicture.asset(currentUserData!.image), // Use user's image
                    ),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              )
        ) : Container(),
      );
  }

  
void showProfileOverlay(BuildContext context) { // Add the context parameter
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
          body: Profile(),
        ),
      ),
    );
  }
}