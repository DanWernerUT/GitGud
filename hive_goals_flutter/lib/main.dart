import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/pages/home.dart';
import 'package:hive_goals_flutter/pages/goals.dart';
import 'package:hive_goals_flutter/widgets/bottom_nav.dart';
import 'package:hive_goals_flutter/pages/create_goal.dart';
import 'package:hive_goals_flutter/pages/create_event.dart';
import 'package:hive_goals_flutter/services/app_state.dart';
import 'package:hive_goals_flutter/pages/contacts.dart';
import 'package:hive_goals_flutter/pages/connections.dart';
import 'package:hive_goals_flutter/pages/profile.dart';
import 'package:hive_goals_flutter/pages/calendar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HiveGoals());
}

class HiveGoals extends StatefulWidget {
  const HiveGoals({super.key});

  @override
  State<HiveGoals> createState() => _HiveGoalsState();
}

class _HiveGoalsState extends State<HiveGoals> {
  
  int _selectedIndex = 2;  // Default selected index is 0 (home page)

  // Define a method to change screen based on the selected index
  void _onTabTapped(int index) {
  if (index == 3 || index == 6) {
    // Do nothing when index is 3 or 6
    return;
  }
  setState(() {
    _selectedIndex = index;
  });
}

  @override
  void initState() {
    super.initState();
    AppState().changeTabCallback = _onTabTapped;
  }


  Widget _buildScreenForIndex(int index) {
    switch (index) {
      case 0:
        return ConnectionsPage();
      case 1:
        return ContactsPage(); 
      case 2:
        return MyHomePage();
      case 4:
        return ScheduleScreen();
      case 5:
        return const CreateEventPage();
      case 7:
        return const CreateGoalPage();
      case 8:
        return const UserGoalPage();
      case 9:
        return ProfilePage();
      default:
        return MyHomePage();
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
          return Scaffold(
            backgroundColor: HiveColors.background,
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
          );
        }
      ),
    );
  }
}
