import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_goals_flutter/pages/home.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 2), () {
      if (!mounted) return; 
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MyHomePage(title: 'Welcome @username'),
        ),
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: HiveColors.lavender,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              SvgPicture.asset(
              'lib/res/HiveGoalsLight.svg',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              "Hive Goals", 
              style: TextStyle (
                fontWeight: FontWeight.bold,
                // fontStyle: FontStyle.italic,
                color: Colors.white,
                fontSize: 40,
            ),)
          ],
        )
      ),
    );
  }
}