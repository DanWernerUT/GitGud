import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';

class HiveText extends StatelessWidget {
  final String title;
  final TextStyle style;

  // Constructor to accept dynamic title and style
  const HiveText({
    super.key, // converted to a super parameter
    required this.title,
    required this.style,
    Color? color,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style,
    );
  }

  static Text   lightBody(String title, {Key? key, Color? color}) {return Text(title, key: key, style: TextStyle(fontFamily: 'Raleway-ExtraBold', fontSize: 16, fontWeight: FontWeight.w400, color: color ?? HiveColors.platinum,),);}
  static Text    boldBody(String title, {Key? key, Color? color}) {return Text(title, key: key, style: TextStyle(fontFamily: 'Raleway-ExtraBold', fontSize: 24, fontWeight: FontWeight.w600, color: color ?? HiveColors.platinum),);}
  static Text   subHeader(String title, {Key? key, Color? color}) {return Text(title, key: key, style: TextStyle(fontFamily: 'Mojangles', fontSize: 24, fontWeight: FontWeight.w400, color: color ?? HiveColors.platinum),);}
  static Text normalTitle(String title, {Key? key, Color? color}) {return Text(title, key: key, style: TextStyle(fontFamily: 'Raleway-Bold', fontSize: 36, fontWeight: FontWeight.w900, color: color ?? HiveColors.platinum,),);}
  static Text   boldTitle(String title, {Key? key, Color? color}) {return Text(title, key: key, style: TextStyle(fontFamily: 'Raleway-ExtraBold', fontSize: 40, fontWeight: FontWeight.w900, color: color ?? HiveColors.platinum,),);}
  static Text     caption(String title, {Key? key, Color? color}) {return Text(title, key: key, style: TextStyle(fontFamily: 'Mojangles', fontSize: 14, fontWeight: FontWeight.w400, color: color ?? HiveColors.platinum,),);}
}