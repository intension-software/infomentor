import 'package:flutter/material.dart';
import 'package:infomentor/screens/Test.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          color: AppColors.getColor('mono').black.withOpacity(0.1),
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
      style: TextStyle(color: AppColors.getColor('mono').black), // Set the text color to black
      cursorColor: Colors.transparent, // Set the cursor color to transparent
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: text,
        hintText: '', // Remove the text in the left corner when active
        filled: true, // Add a background color to the TextField
        fillColor: AppColors.getColor('mono').white, // Set the background color to white
         border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: borderColor ?? AppColors.getColor('mono').white, // Use the provided borderColor or fallback to white if null
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: borderColor ?? AppColors.getColor('mono').white, // Use the provided borderColor or fallback to white if null
          width: 2.0,
        ),
      ),
        focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
            color: AppColors.getColor('green').main, // Set the focused border color to green
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
  final bool leftIcon;
  final bool rightIcon;
  final bool isDisabled;

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
    this.leftIcon = false,
    this.rightIcon = false,
    this.isDisabled = false,
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
            if (widget.leftIcon) Icon(Icons.close, color: widget.iconColor), // Replace with your desired icon
            Text(
              widget.text!,
              style: TextStyle(
                color: widget.textColor!,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.rightIcon) Icon(Icons.arrow_forward, color: widget.iconColor), // Replace with your desired icon
          ],
        ),
        style: ButtonStyle(
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
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        ),
      ),
    );
  }
}

Container reTileImage(Color color, Color borderColor, int index, String? item, BuildContext context, {List<dynamic>? percentage, bool? correct}) {
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
            .headlineSmall!
            .copyWith(
              color: borderColor,
            )
          ),
          leading: percentage == [] || percentage == null ? correct == null ? Radio(
        value: index,
        groupValue: null,
        fillColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
        onChanged: null,
      ) : correct ? SvgPicture.asset('assets/icons/correctIcon.svg') : SvgPicture.asset('assets/icons/falseIcon.svg') : Text('${percentage[index]}%', style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(
              color: borderColor,
            )
          ),
        ),
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
             leading: percentage == [] || percentage == null ? correct == null ? Radio(
                value: index,
                groupValue: _answer,
                activeColor: AppColors.getColor('mono').lightGrey,
                onChanged: null,
              ) : correct ? SvgPicture.asset('assets/icons/correctIcon.svg') : SvgPicture.asset('assets/icons/falseIcon.svg') : Text('${percentage[index]}%', style: Theme.of(context)
            .textTheme
            .headlineSmall!
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
          ),
        ),
      )
    ],
  ),
);


}


Container reTile(Color color, Color borderColor, int index, String? item, BuildContext context, {List<dynamic>? percentage, bool? correct}) {
  return Container(
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: borderColor,width: 1),
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
          .headlineSmall!
          .copyWith(
            color: borderColor,
        ),
      ), 
      leading: percentage == [] || percentage == null ? correct == null ? Radio(
        value: index,
        groupValue: null,
        activeColor: AppColors.getColor('mono').lightGrey,
        onChanged: null,
      ) : correct ? SvgPicture.asset('assets/icons/correctIcon.svg') : SvgPicture.asset('assets/icons/falseIcon.svg') : Text('${percentage[index]}%', style: borderColor == AppColors.getColor('mono').lightGrey ? Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(
              color: borderColor,
            ): Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(
              color: borderColor,
            )
          ),
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

  SvgDropdownPopupMenuButton({
    required this.onUpdateSelected,
    required this.onDeleteSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: 'update',
            child: Text('upraviť'),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Text('vymazať'),
          ),
        ];
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
    );
  }
}
