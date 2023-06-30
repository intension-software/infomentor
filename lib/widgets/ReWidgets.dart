import 'package:flutter/material.dart';
import 'package:infomentor/screens/Test.dart';
import 'package:infomentor/Colors.dart';


Container reTextField(
  String text,
  bool isPasswordType,
  TextEditingController controller,
  Color? borderColor,
) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: AppColors.mono.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      style: TextStyle(color: AppColors.mono.black), // Set the text color to black
      cursorColor: Colors.transparent, // Set the cursor color to transparent
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: text,
        hintText: '', // Remove the text in the left corner when active
        filled: true, // Add a background color to the TextField
        fillColor: AppColors.mono.white, // Set the background color to white
         border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: borderColor ?? AppColors.mono.white, // Use the provided borderColor or fallback to white if null
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: borderColor ?? AppColors.mono.white, // Use the provided borderColor or fallback to white if null
          width: 2.0,
        ),
      ),
        focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
            color: AppColors.green.main, // Set the focused border color to green
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
      ),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    ),
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
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
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

class reStateIcon extends StatefulWidget {
  final Function onClick;
  final String currentImage;
  final String newImage;

  reStateIcon({required this.onClick, required this.currentImage, required this.newImage});

  @override
  _reStateIconState createState() => _reStateIconState();
}

class _reStateIconState extends State<reStateIcon> {
  bool isCurrentImage = true;

  void changeImage() {
    setState(() {
      isCurrentImage = !isCurrentImage;
    });
    widget.onClick();
  }

  @override
  Widget build(BuildContext context) {
    final String currentImage = isCurrentImage ? widget.currentImage : widget.newImage;

    return GestureDetector(
      onTap: changeImage,
      child: Image.asset(
        currentImage,
      ),
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
