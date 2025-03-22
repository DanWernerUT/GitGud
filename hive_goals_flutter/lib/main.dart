import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/pages/home.dart';
import 'package:hive_goals_flutter/pages/goals.dart';
import 'package:hive_goals_flutter/widgets/bottom_nav.dart';
import 'package:hive_goals_flutter/pages/create_goal.dart';
import 'package:hive_goals_flutter/services/app_state.dart';

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
  
  int _selectedIndex = 0;  // Default selected index is 0 (home page)

  // Define a method to change screen based on the selected index
  void _onTabTapped(int index) {
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
        return const Center(child: Text('Connections Page'));
      case 1:
        return const Center(child: Text('Messages Page'));
      case 2:
        return const Center(child: Text('Create Goal Screen'));
      case 3:
        // Calendar menu itself
        return const Center(child: Text('Calendar Menu'));
      case 4:
        return const Center(child: Text('View Calendar'));
      case 5:
        return const Center(child: Text('Create Event'));
      case 6:
        // Goals menu itself
        return const Center(child: Text('Goals Menu'));
      case 7:
        return const CreateGoalPage();
      case 8:
        return const UserGoalPage();
      default:
        return const MyHomePage(title: 'Hive Goals Home');
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
