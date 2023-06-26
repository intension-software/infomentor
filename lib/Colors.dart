import 'package:flutter/material.dart';


class Shades {
  final Color main;
  final Color lighter;
  final Color light;

  Shades({
    required this.main,
    required this.lighter,
    required this.light,
  });
}

class MonochronicShades {
  final Color black;
  final Color darkGrey;
  final Color grey;
  final Color lightGrey;
  final Color lighterGrey;
  final Color white;

  MonochronicShades({
    required this.black,
    required this.darkGrey,
    required this.grey,
    required this.lightGrey,
    required this.lighterGrey,
    required this.white,
  });
}

class FocusShades {
  final Color blue;
  final Color white;

  FocusShades({
    required this.blue,
    required this.white,
  });
}

class AppColors {
  static final Shades primary = Shades(
    main: Color(0xff1660B8),
    light: Color(0xff186BCC),
    lighter: Color(0xffD1E1F5),
  );

  static final Shades blue = Shades(
    main: Color(0xff1660B8),
    light: Color(0xff186BCC),
    lighter: Color(0xffD1E1F5),
  );

  static final Shades green = Shades(
    main: Color(0xff369C8B),
    light: Color(0xff3CAD9A),
    lighter: Color(0xffD8EFEB),
  );

  static final Shades yellow = Shades(
    main: Color(0xffE0A800),
    light: Color(0xffF9BB00),
    lighter: Color(0xffFEF1CC),
  );

  static final Shades orange = Shades(
    main: Color(0xffE3673A),
    light: Color(0xffFC7341),
    lighter: Color(0xffFEE3D9),
  );
  static final Shades red = Shades(
    main: Color(0xffD04355),
    light: Color(0xffE74B5E),
    lighter: Color(0xffFADBDF),
  );
  static final Shades pink = Shades(
    main: Color(0xffCE598A),
    light: Color(0xffE56399),
    lighter: Color(0xffFAE0EB),
  );
  static final MonochronicShades mono = MonochronicShades(
    black: Colors.black,
    darkGrey: Color(0xff747474),
    grey: Color(0xffA6A6A6),
    lightGrey: Color(0xffE9E9E9),
    lighterGrey: Color(0xffF6F6F6),
    white: Colors.white,
  );
   static final FocusShades focused = FocusShades(
    blue: Color(0xff186BCC80),
    white: Colors.white,
  );
}