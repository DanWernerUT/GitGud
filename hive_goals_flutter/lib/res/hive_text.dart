import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';

class HiveText extends StatelessWidget {
  final String title;
  final TextStyle style;

  // Constructor to accept dynamic title and style
  const HiveText({
    Key? key, // key is passed as a super parameter
    required this.title,
    required this.style,
    Color? color,
  }) : super(key: key); 
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style,
    );
  }

  // Static method for a default light body text style
  static Text   lightBody(String title) {return Text(title, style: TextStyle(fontFamily: 'Mojangles', fontSize: 36, fontWeight: FontWeight.w400, color: HiveColors.platinum),);}
  static Text normalTitle(String title) {return Text(title, style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: HiveColors.platinum,),);}
  static Text   boldTitle(String title) {return Text(title, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: HiveColors.platinum,),);}
  static Text     caption(String title) {return Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: HiveColors.platinum,),);}
}