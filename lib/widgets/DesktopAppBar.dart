import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/screens/Profile.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/widgets/DropDown.dart';
import 'package:infomentor/widgets/NotificationsDropDown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DesktopAppBar extends StatefulWidget implements PreferredSizeWidget {
  final FetchResult? capitol;
  final UserData? currentUserData;
  final int? capitolLength;
  final Function(int) onNavigationItemSelected;
  final VoidCallback? onUserDataChanged;
  int selectedIndex;


  DesktopAppBar({
    Key? key,
    required this.capitol,
    required this.currentUserData,
    required this.capitolLength,
    required this.onNavigationItemSelected,
    required this.selectedIndex,
    this.onUserDataChanged,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);

  @override
  _DesktopAppBarState createState() => _DesktopAppBarState();
}

class _DesktopAppBarState extends State<DesktopAppBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero, // Remove the padding
      child: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 1,
        flexibleSpace: widget.currentUserData != null && widget.capitol != null
            ? SafeArea(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      SvgPicture.asset(
                        'assets/logoFilled.svg',
                        height: 30,
                      ),
                      SizedBox(width: 20),
                      buildNavItem(0, "assets/icons/homeIcon.svg", "assets/icons/homeFilledIcon.svg", "Domov", context),
                      buildNavItem(1, "assets/icons/starIcon.svg", "assets/icons/starWhiteIcon.svg", "Výzva", context),
                      buildNavItem(2, "assets/icons/textBubblesIcon.svg", "assets/icons/textBubblesFilledIcon.svg", "Diskusia", context),
                      buildNavItem(3, "assets/icons/bookIcon.svg", "assets/icons/bookFilledIcon.svg", "Vzdelávanie", context),
                      if(widget.currentUserData!.teacher)buildNavItem(6, "assets/icons/bookIcon.svg", "assets/icons/bookFilledIcon.svg", "Výsledky", context),
                      if(widget.currentUserData!.admin)buildNavItem(7, "assets/icons/bookIcon.svg", "assets/icons/bookFilledIcon.svg", "Admin", context),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(!widget.currentUserData!.teacher) Text(
                            '${widget.currentUserData!.points}/${widget.capitolLength ?? 0}',
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: AppColors.getColor('yellow').light,
                                ),
                          ),
                          SizedBox(width: 8),
                          if(!widget.currentUserData!.teacher) SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                          if(widget.currentUserData!.teacher)DropDown(currentUserData: widget.currentUserData, onUserDataChanged: widget.onUserDataChanged,),
                          SizedBox(width: 16),
                          NotificationsDropDown(
                            currentUserData: widget.currentUserData, // Pass your user data
                            onNavigationItemSelected: widget.onNavigationItemSelected,
                            selectedIndex: widget.selectedIndex,
                          ),
                          SizedBox(width: 16),
                          SvgPicture.asset('assets/icons/infoIcon.svg'),
                          SizedBox(width: 20),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                widget.onNavigationItemSelected(5);
                                widget.selectedIndex = -1;
                              },
                              child: SvgPicture.asset(widget.currentUserData!.image),
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      )
                    ],
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  Widget buildNavItem(int index, String icon, String filledIcon, String text, BuildContext context) {
  final bool isSelected = index == widget.selectedIndex;

  return Container(
    width: 150,
    height: 200,
    decoration: isSelected
        ? BoxDecoration(
            color: Theme.of(context).primaryColor,
          )
        : null,
    child: InkWell(
      onTap: () {
        setState(() {
          widget.selectedIndex = index;
        });
        widget.onNavigationItemSelected(index);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isSelected ? SvgPicture.asset(filledIcon) : SvgPicture.asset(icon),
          SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: isSelected ? Theme.of(context).colorScheme.onPrimary : AppColors.getColor('mono').black,
            ),
          ),
        ],
      ),
    ),
  );
}

}