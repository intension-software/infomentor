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
import 'package:infomentor/widgets/ReWidgets.dart';

class DesktopAppBar extends StatefulWidget implements PreferredSizeWidget {
  final FetchResult? capitol;
  final UserData? currentUserData;
  final Function(int) onNavigationItemSelected;
  final VoidCallback? onUserDataChanged;
  int selectedIndex;
  final void Function() tutorial;


  DesktopAppBar({
    Key? key,
    required this.capitol,
    required this.currentUserData,
    required this.onNavigationItemSelected,
    required this.selectedIndex,
    this.onUserDataChanged,
    required this.tutorial
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
                      buildNavItem(0, "assets/icons/homeIcon.svg","Domov", context),
                      buildNavItem(1, "assets/icons/starIcon.svg", "Výzvy", context),
                      buildNavItem(2, "assets/icons/textBubblesIcon.svg", "Diskusia", context),
                      buildNavItem(3, "assets/icons/bookIcon.svg",  "Vzdelávanie", context),
                      if(widget.currentUserData!.teacher)buildNavItem(4, "assets/icons/resultsIcon.svg",  "Výsledky", context),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(!widget.currentUserData!.teacher) Text(
                            '${widget.currentUserData!.points}/135',
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: AppColors.getColor('yellow').light,
                                ),
                          ),
                          SizedBox(width: 8),
                          if(!widget.currentUserData!.teacher) SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                          if(widget.currentUserData!.teacher && widget.currentUserData!.classes.length > 0)DropDown(currentUserData: widget.currentUserData, onUserDataChanged: widget.onUserDataChanged,),
                          SizedBox(width: 16),
                          NotificationsDropDown(
                            currentUserData: widget.currentUserData, // Pass your user data
                            onNavigationItemSelected: widget.onNavigationItemSelected,
                            selectedIndex: widget.selectedIndex,
                          ),
                          if(!widget.currentUserData!.teacher)SizedBox(width: 16),
                          IconButton(
                            icon: SvgPicture.asset('assets/icons/infoIcon.svg'),
                            onPressed: () {
                              widget.tutorial();
                            },
                          ),
                          if(!widget.currentUserData!.teacher)SizedBox(width: 16),
                          if(!widget.currentUserData!.teacher)MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                widget.onNavigationItemSelected(5);
                                widget.selectedIndex = -1;
                              },
                              child: CircularAvatar(name: widget.currentUserData!.name, width: 16, fontSize: 16,),
                            ),
                          ),
                          if(widget.currentUserData!.teacher)SizedBox(width: 16),
                          if(widget.currentUserData!.teacher)IconButton(
                            icon: SvgPicture.asset('assets/icons/adminIcon.svg'),
                            onPressed: () {
                              widget.onNavigationItemSelected(6);
                              widget.selectedIndex = -1;
                            }
                          ),
                          
                          SizedBox(width: 30),
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

  Widget buildNavItem(int index, String icon, String text, BuildContext context) {
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
          isSelected ? SvgPicture.asset(icon, color: isSelected ? Theme.of(context).colorScheme.onPrimary : AppColors.getColor('mono').black) : SvgPicture.asset(  icon, color: isSelected ? Theme.of(context).colorScheme.onPrimary : AppColors.getColor('mono').black,),
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