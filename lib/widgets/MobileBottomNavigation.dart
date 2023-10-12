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

  List<String> labels = ['Domov', 'Výzva', 'Diskusia', 'Vzdelávanie'];

  @override
  Widget build(BuildContext context) {
    // Define the item color based on the selectedIndex
    Color getItemColor(int index) {
      if (widget.selectedIndex < 0 || widget.selectedIndex > 3) {
        return AppColors.getColor('mono').grey; // Gray color when selectedIndex is -1
      } else {
        return widget.selectedIndex == index
            ? Theme.of(context).primaryColor
            : AppColors.getColor('mono').grey;
      }
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: getItemColor(widget.selectedIndex),
      unselectedItemColor: AppColors.getColor('mono').grey,
      selectedFontSize: 14.0,
      unselectedFontSize: 14.0,
      items: List<BottomNavigationBarItem>.generate(
        normalSvgPaths.length,
        (index) {
          final normalSvgPath = normalSvgPaths[index];
          final selectedSvgPath = selectedSvgPaths[index];

          return BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: SvgPicture.asset(
                widget.selectedIndex == index ? selectedSvgPath : normalSvgPath,
                width: 24,
                height: 24,
                color: getItemColor(index), // Use the getItemColor function
              ),
            ),
            label: labels[index],
          );
        },
      ),
      currentIndex: widget.selectedIndex < normalSvgPaths.length
          ? widget.selectedIndex
          : 0,
      onTap: widget.onItemTapped,
    );
  }

 
}
