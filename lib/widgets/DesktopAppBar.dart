import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/screens/Profile.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/ReWidgets.dart';

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
                      Image.asset(
                        'assets/logoFilled.png',
                        height: 30,
                      ),
                      SizedBox(width: 20),
                      buildNavItem(0, "assets/icons/homeIcon.png", "assets/icons/homeFilledIcon.png", "Domov", context),
                      buildNavItem(1, "assets/icons/starIcon.png", "assets/icons/starWhiteIcon.png", "Výzva", context),
                      buildNavItem(2, "assets/icons/textBubblesIcon.png", "assets/icons/textBubblesFilledIcon.png", "Diskusia", context),
                      buildNavItem(3, "assets/icons/bookIcon.png", "assets/icons/bookFilledIcon.png", "Vzdelávanie", context),
                      Spacer(),
                      Text(
                        '${widget.currentUserData!.points}/${widget.capitolLength ?? 0}',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: AppColors.yellow.light,
                            ),
                      ),
                      SizedBox(width: 8),
                      Image.asset('assets/icons/starYellowIcon.png'),
                      SizedBox(width: 16),
                      Image.asset('assets/icons/bellIcon.png'),
                      SizedBox(width: 16),
                      Image.asset('assets/icons/infoIcon.png'),
                      SizedBox(width: 20),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            showProfileOverlay(context);
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.currentUserData!.image),
                          ),
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
          isSelected ? Image.asset(filledIcon) : Image.asset(icon),
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



  void showProfileOverlay(BuildContext context) {
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
