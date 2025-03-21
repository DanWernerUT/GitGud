import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/pages/splash.dart';
import 'package:hive_goals_flutter/pages/home.dart';
import 'package:hive_goals_flutter/pages/goals.dart';
import 'package:hive_goals_flutter/widgets/bottom_nav.dart';
import 'package:hive_goals_flutter/pages/create_goal.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HiveGoals());
}

class HiveGoals extends StatefulWidget {
  const HiveGoals({super.key});

  @override
  _HiveGoalsState createState() => _HiveGoalsState();
}

class _HiveGoalsState extends State<HiveGoals> {
  int _selectedIndex = 0;  // Default selected index is 0 (home page)

  // Define a method to change screen based on the selected index
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Method to build screens based on selected tab index
  Widget _buildScreenForIndex(int index) {
    switch (index) {
      case 0:
        return Center(child: Text('Connections Page'));
      case 1:
        return Center(child: Text('Messages Page'));
      case 2:
        return Center(child: Text('Create Goal Screen'));
      case 4:
        return Center(child: Text('View Calendar'));
      case 5:
        return Center(child: Text('Create Event'));
      case 7:
        return CreateGoalPage();
        // return Center(child: Text('Create Goal'));
      case 8:
        return UserGoalPage();
      default:
        return MyHomePage(title: 'Hive Goals Home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Goals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: HiveColors.background),
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(
            physics: const ClampingScrollPhysics(), // Prevents overscroll stretching
            overscroll: false, // Disables the overscroll glow effect
          ),
          child: child!,
        );
      },
      home: Builder(
        builder: (context) {
          // Using Builder to get the correct context for MediaQuery
          return Scaffold(
            backgroundColor: HiveColors.background,
            // appBar: AppBar(
            //   backgroundColor: HiveColors.platinum,
            //   title: Text('Hive Goals'),
            // ),
            // The body now fills the entire space beneath the AppBar
            body: Stack(
              children: [
                // Your page content
                _buildScreenForIndex(_selectedIndex),
                
                // Bottom navigation bar that sits on top of everything
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BottomNavBar(
                    currentIndex: _selectedIndex, 
                    onTap: _onTabTapped,
                  ),
                ),
              ],
            ),
            // Remove the bottomNavigationBar property from Scaffold
            // bottomNavigationBar: null,
          );
        }
      ),
    );
  }
}