import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Domov',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border_outlined),
          label: 'Výzva',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Diskusia',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded),
          label: 'Vzdelávanie',
        ),
      ],
      currentIndex: widget.selectedIndex < 3 ? widget.selectedIndex : 0,
      unselectedItemColor: AppColors.getColor('mono').grey,
      selectedItemColor: Theme.of(context).primaryColor,
      onTap: widget.onItemTapped,
    );
  }
}