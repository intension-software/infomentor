import 'dart:js';

import 'package:flutter/material.dart';
import 'package:infomentor/Tests/DesktopTest.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

Container reTextField(
  String text,
  bool isPasswordType,
  TextEditingController controller,
  Color? borderColor,
  {bool? visibility, Function()? toggle}
) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: AppColors.getColor('mono').black.withOpacity(0.1),
          spreadRadius: 0.5,
          blurRadius: 5,
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      obscureText: visibility ?? false,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      style: TextStyle(color: AppColors.getColor('mono').black),
      cursorColor: Colors.transparent,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: text,
        hintText: '',
        filled: true,
        fillColor: AppColors.getColor('mono').white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.getColor('mono').white,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.getColor('mono').white,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.getColor('green').main,
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
        // Add a suffix icon (eye) to toggle password visibility when isPasswordType is true
         suffixIcon: isPasswordType
        ? StatefulBuilder(
            builder: (context, setState) {

              return Padding(
                padding: EdgeInsets.only(left: 20.0), // Adjust the left padding as needed
                child: IconButton(
                  icon: Icon(
                    visibility ?? false ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: AppColors.getColor('mono').darkGrey,
                  ),
                  onPressed: toggle,
            ),
              );
            },
          )
        : null,
      ),
    ),
  );
}


class ReButton extends StatefulWidget {
  final String? text;
  final Color? defaultColor;
  final Color? hoverColor;
  final Color? focusedColor;
  final Color? disabledColor;
  final Color? activeColor;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? iconColor;
  final Function? onTap;
  final String? leftIcon;
  final String? rightIcon;
  final bool isDisabled;
  final bool bold;

  ReButton({
    this.text = '',
    this.defaultColor = Colors.green,
    this.hoverColor = Colors.green,
    this.focusedColor = Colors.green,
    this.disabledColor = Colors.grey,
    this.activeColor = Colors.green,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.green,
    this.iconColor = Colors.white,
    this.onTap,
    this.leftIcon,
    this.rightIcon,
    this.isDisabled = false,
    this.bold = false,
  });

  @override
  _ReButtonState createState() => _ReButtonState();
}

class _ReButtonState extends State<ReButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: widget.isDisabled ? null : () => widget.onTap!(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (widget.leftIcon != null)
              SvgPicture.asset(
                widget.leftIcon ?? '',
                color: widget.textColor,
              ), // Replace with your desired icon
            Text(
              widget.text!,
              style: TextStyle(
                color: widget.textColor,
                fontFamily: widget.bold ? GoogleFonts.inter(fontWeight: FontWeight.w500).fontFamily : GoogleFonts.inter(fontWeight: FontWeight.w400).fontFamily
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(width: 10,),
            if (widget.rightIcon != null)
              SvgPicture.asset(
                widget.rightIcon ?? '',
                color: widget.textColor,
              ), // Replace with your desired icon
          ],
        ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0), // Set elevation to 0 for a flat appearance
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return widget.disabledColor!;
            } else if (states.contains(MaterialState.pressed)) {
              return widget.activeColor!;
            } else if (states.contains(MaterialState.hovered)) {
              return widget.hoverColor!;
            } else {
              return widget.defaultColor!;
            }
          }),
          side: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return BorderSide(color: widget.focusedColor!, width: 2);
            } else {
              return BorderSide.none;
            }
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}

Container reTileImage(Color color, Color borderColor, int index, String? item, BuildContext context, {List<dynamic>? percentage, bool? correct, Color? percentageColor}) {
  return Container(
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(10),
      color: color,
    ),
    child: Column(
      children: [
        if (item != null && item.isNotEmpty) Image.asset(item, fit: BoxFit.cover),
        ListTile(
          title: Text('Obrázok ${index + 1}',
          style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(
              color: borderColor,
            )
          ),
          leading: percentage == [] || percentage == null ? correct == null ? Text('${String.fromCharCode('a'.codeUnitAt(0) + index)})',
                style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  ,
              ) : correct ? Text('${String.fromCharCode('a'.codeUnitAt(0) + index)})',
                  style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(
                      color: AppColors.getColor('green').main,
                    ),
                ) : Text('${String.fromCharCode('a'.codeUnitAt(0) + index)})',
                    style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(
                        color: AppColors.getColor('red').main,
                      ),
                  ) : Text('${percentage[index]}%', style:Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(
              color: percentageColor,
            )
          ),
          trailing: correct != null ? correct ?  SvgPicture.asset('assets/icons/correctIcon.svg') : SvgPicture.asset('assets/icons/falseIcon.svg'): null,
        )
      ],
    ),
  );
}

Container reTileMatchmaking(
  Color color,
  Color borderColor,
  int _answer,
  int index,
  String? text,
  BuildContext context,
  List<String> matches,
  bool? correct,
  {List<dynamic>? percentage}) {

  return Container(
  margin: EdgeInsets.all(8),
  decoration: BoxDecoration(
    border: Border.all(color: AppColors.getColor('mono').lightGrey),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Column(
    children: [
      if (text != null && text.isNotEmpty)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text,
          style: Theme.of(context)
            .textTheme
            .headlineSmall!,
          ),
        ),
      MouseRegion(
        cursor: SystemMouseCursors.basic,  // This will prevent the cursor from changing on hover
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
            color: color,
          ),
          child: ListTile(
             leading: percentage == [] || percentage == null ? correct == null ? Text('${String.fromCharCode('a'.codeUnitAt(0) + index)})',
                style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  ,
              ) : correct ? Text('${String.fromCharCode('a'.codeUnitAt(0) + index)})',
                  style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(
                      color: AppColors.getColor('green').main,
                    ),
                ) : Text('${String.fromCharCode('a'.codeUnitAt(0) + index)})',
                    style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(
                        color: AppColors.getColor('red').main,
                      ),
                  ) : Text('${percentage[index]}%', style:Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(
              color: borderColor,
            )
          ),  // replace with your desired icon
            title: Text(matches[_answer ?? 0],
            style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(
                color: borderColor,
            ),
            ),  // default text displayed
            contentPadding: EdgeInsets.zero,  // to remove any default padding in ListTile
            trailing: correct != null ? correct ?  SvgPicture.asset('assets/icons/correctIcon.svg') : SvgPicture.asset('assets/icons/falseIcon.svg'): null,
          ),
        ),
      )
    ],
  ),
);


}


Container reTile(Color color, Color borderColor, int index, String? item, BuildContext context, {List<dynamic>? percentage, bool? correct, Color? percentageColor}) {
  return Container(
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: borderColor,width: 2),
      borderRadius: BorderRadius.circular(10),
      color: color,
    ),
    child: ListTile(
      title: borderColor == AppColors.getColor('mono').lightGrey ? Text(item ?? '',
        style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(
            color:  AppColors.getColor('mono').black,
        ),
      ) : Text(item ?? '',
        style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(
            color: borderColor,
        ),
      ), 
      leading: percentage == [] || percentage == null ? correct == null ? Text('${String.fromCharCode('a'.codeUnitAt(0) + index)})',
                style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  ,
              ) : correct ? Text('${String.fromCharCode('a'.codeUnitAt(0) + index)})',
                  style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(
                      color: AppColors.getColor('green').main,
                    ),
                ) : Text('${String.fromCharCode('a'.codeUnitAt(0) + index)})',
                    style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(
                        color: AppColors.getColor('red').main,
                      ),
                  ) : Text('${percentage[index]}%', style:Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(
              color: percentageColor,
            )
          ),
          trailing: correct != null ? correct ?  SvgPicture.asset('assets/icons/correctIcon.svg') : SvgPicture.asset('assets/icons/falseIcon.svg'): null,

    ),
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

class SvgDropdownPopupMenuButton extends StatelessWidget {
  final Function() onUpdateSelected;
  final Function() onDeleteSelected;
  final bool showEditOption; // Add a flag to control whether to show the edit option.

  SvgDropdownPopupMenuButton({
    required this.onUpdateSelected,
    required this.onDeleteSelected,
    this.showEditOption = true, // Set a default value for the flag.
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      
      itemBuilder: (BuildContext context) {
        final List<PopupMenuEntry<String>> menuItems = [];

        if (showEditOption) { // Check if the edit option should be shown.
          menuItems.add(
            PopupMenuItem(
              value: 'update',
              child: Text('upraviť'),
            ),
          );
        }

        menuItems.add(
          PopupMenuItem(
            value: 'delete',
            child: Text('vymazať'),
          ),
        );

        return menuItems;
      },
      onSelected: (String value) {
        if (value == 'update') {
          onUpdateSelected();
        } else if (value == 'delete') {
          onDeleteSelected();
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              child: SvgPicture.asset('assets/icons/verticalDotsIcon.svg'),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
      ),
      offset: Offset(-10, 30), // Adjust the vertical offset to move the popup slightly lower
    );
  }
}

void reShowToast(String message, bool error, BuildContext context) {
  showToastWidget(
    Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: error ? AppColors.getColor('red').main : AppColors.getColor('green').main,
          width: 2
        ),
        color: error ? AppColors.getColor('red').lighter : AppColors.getColor('green').lighter
      ),
      child: Row(
        children: [
          Text(message, style: TextStyle(color: Colors.black),),
          Spacer(),
          Text('Späť', style: TextStyle(color: error ? AppColors.getColor('red').main : AppColors.getColor('green').main),),
          SvgPicture.asset('assets/icons/xIcon.svg', color: error ? AppColors.getColor('red').main : AppColors.getColor('green').main),
        ],
      ),
    ),
    context: context,
    isIgnoring: false,
    duration: Duration(seconds: 5),
    position: StyledToastPosition(align: Alignment.bottomRight)
  );
}

class CircularAvatar extends StatelessWidget {
  final String name;
  final double width;
  final double fontSize;

  CircularAvatar({required this.name, required this.width, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    // Capitalize the first letter of the name
    String initial = name.isNotEmpty ? name[0].toUpperCase() : '';

    return  Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.getColor('blue').lighter, // Border color
            radius: width, // Adjust the size as needed
          ),
          Text(
            initial,
            style: TextStyle(
              color: AppColors.getColor('blue').main, // Text color same as border color
              fontSize: fontSize, // Adjust the font size as needed
            ),
          ),
        ],
      );
  }
}








