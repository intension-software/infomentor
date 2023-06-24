import 'package:flutter/material.dart';
import 'package:infomentor/screens/Test.dart';

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

class reBottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const reBottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _reBottomNavigationState createState() => _reBottomNavigationState();
}

class _reBottomNavigationState extends State<reBottomNavigation> {
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
      currentIndex: widget.selectedIndex,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Color(0xff4b4fb3),
      onTap: widget.onItemTapped,
    );
  }
}

Container reImageAnswer(String image) {
  return Container(
    margin:  EdgeInsets.fromLTRB(0, 0, 0, 32),
    padding:  EdgeInsets.fromLTRB(8, 8, 8, 8),
    width:  double.infinity,
    height:  247,
    decoration:  BoxDecoration (
      image:  DecorationImage (
        fit:  BoxFit.cover,
        image:  NetworkImage (
          image
        ),
      ),
    ),
  );
}
