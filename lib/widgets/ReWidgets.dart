import 'package:flutter/material.dart';

TextField reTextField(
    String text, bool isPasswordType, TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    decoration: InputDecoration(
      labelText: text,
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container reButton(BuildContext context, String text, int color, int pressColor, int textColor, dynamic onTap) {
  return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.circular(90),
      ),
      child: ElevatedButton(
        onPressed: () => onTap()
        ,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            selectionColor: Color(textColor),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Color(pressColor);
            }
            return Color(color);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
        )
      )
    );
}

Image reImage(String image, double width, double height) {
  return Image.asset(
    image,
    fit: BoxFit.fitWidth,
    width: width,
    height: height
  );
}

class reBottomNavigationApp extends StatelessWidget {
  const reBottomNavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: reBottomNavigation(),
    );
  }
}

class reBottomNavigation extends StatefulWidget {
  const reBottomNavigation({super.key});

  @override
  State<reBottomNavigation> createState() =>
      _reBottomNavigationState();
}

class _reBottomNavigationState
    extends State<reBottomNavigation> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Domov',
      style: optionStyle,
    ),
    Text(
      'Index 1: Výzva',
      style: optionStyle,
    ),
    Text(
      'Index 2: Diskusia',
      style: optionStyle,
    ),
    Text(
      'Index 3: Vzdelávanie',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
            icon: Icon(Icons.book_online),
            label: 'Vzdelávanie',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Color(0xff4b4fb3),
        onTap: _onItemTapped,
      );
  }
}
