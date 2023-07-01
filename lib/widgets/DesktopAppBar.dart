import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/screens/Profile.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DesktopAppBar extends StatefulWidget implements PreferredSizeWidget {
  final FetchResult? capitol;
  final UserData? currentUserData;
  final int? capitolLength;
  final Function(int) onNavigationItemSelected;

  DesktopAppBar({
    Key? key,
    required this.capitol,
    required this.currentUserData,
    required this.capitolLength,
    required this.onNavigationItemSelected,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);

  @override
  _DesktopAppBarState createState() => _DesktopAppBarState();
}

class _DesktopAppBarState extends State<DesktopAppBar> {
  int _selectedIndex = 0;

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
                      Spacer(),
                      Text(
                        '${widget.currentUserData!.points}/${widget.capitolLength ?? 0}',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: AppColors.yellow.light,
                            ),
                      ),
                      SizedBox(width: 8),
                      SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                      SizedBox(width: 16),
                      SvgPicture.asset('assets/icons/bellIcon.svg'),
                      SizedBox(width: 16),
                      SvgPicture.asset('assets/icons/infoIcon.svg'),
                      SizedBox(width: 20),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            widget.onNavigationItemSelected(4);
                          },
                          child: SvgPicture.asset(widget.currentUserData!.image),
                        ),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  Widget buildNavItem(int index, String icon, String filledIcon, String text, BuildContext context) {
  final bool isSelected = index == _selectedIndex;

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
          _selectedIndex = index;
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
              color: isSelected ? Theme.of(context).colorScheme.onPrimary : AppColors.mono.black,
            ),
          ),
        ],
      ),
    ),
  );
}
}