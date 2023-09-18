import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/Colors.dart';

class MobileBottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const MobileBottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _MobileBottomNavigationState createState() => _MobileBottomNavigationState();
}

class _MobileBottomNavigationState extends State<MobileBottomNavigation> {
  final List<String> normalSvgPaths = [
    "assets/icons/homeIcon.svg",
    "assets/icons/starIcon.svg",
    "assets/icons/textBubblesIcon.svg",
    "assets/icons/bookIcon.svg",
  ];

  final List<String> selectedSvgPaths = [
    "assets/icons/homeFilledIcon.svg",
    "assets/icons/starWhiteIcon.svg",
    "assets/icons/textBubblesFilledIcon.svg",
    "assets/icons/bookFilledIcon.svg",
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true, // Show selected item's label
      showUnselectedLabels: true, // Show unselected item's label
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: AppColors.getColor('mono').grey,
      selectedFontSize: 14.0, // Set the font size for selected labels
      unselectedFontSize: 14.0, // Set the font size for unselected labels
      items: List<BottomNavigationBarItem>.generate(
        normalSvgPaths.length,
        (index) {
          final normalSvgPath = normalSvgPaths[index];
          final selectedSvgPath = selectedSvgPaths[index];

          return BottomNavigationBarItem(
            icon: SvgPicture.asset(
              widget.selectedIndex == index ? selectedSvgPath : normalSvgPath,
              width: 24,
              height: 24,
              color: widget.selectedIndex == index
                  ? Theme.of(context).primaryColor
                  : AppColors.getColor('mono').grey,
            ),
            label: getLabel(index),
          );
        },
      ),
      currentIndex: widget.selectedIndex < normalSvgPaths.length
          ? widget.selectedIndex
          : 0,
      onTap: widget.onItemTapped,
    );
  }

  String getLabel(int index) {
    switch (index) {
      case 0:
        return 'Domov';
      case 1:
        return 'Výzva';
      case 2:
        return 'Diskusia';
      case 3:
        return 'Vzdelávanie';
      default:
        return '';
    }
  }
}
