import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/models/goal_model.dart';
import 'package:hive_goals_flutter/services/database_helper.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/widgets/top_nav.dart';

class UserGoalPage extends StatefulWidget {
  const UserGoalPage({super.key});

  @override
  State<UserGoalPage> createState() => _UserGoalPageState();
}

class _UserGoalPageState extends State<UserGoalPage> with TickerProviderStateMixin {
  final textController = TextEditingController();
  late AnimationController controllerDaily;
  late AnimationController controllerWeekly;
  late AnimationController controllerMonthly;
  late AnimationController controllerTotal;
  int? selectedId;
  // late Future<List<Goal>> _goalsFuture;
  
  // Maps to track the checked state of each goal
  final Map<String, bool> dailyGoalsChecked = {};
  final Map<String, bool> weeklyGoalsChecked = {};
  final Map<String, bool> monthlyGoalsChecked = {};
  
  final List<String> dailyGoals = [
    'Complete Chapter 7',
    'Finish your taxes',
    'Submit assignment',
  ];

  final List<String> weeklyGoals = [
    'Practice piano',
    'Walk the Dog',
    'Go to the gym x3',
  ];

  final List<String> monthlyGoals = [
    "Save 1,000 dollars",
    'Finish Prototype',
  ];

  @override
  void initState() {
    super.initState();
    controllerDaily   = AnimationController(vsync: this, duration: const Duration(seconds: 1), value: 0.76);
    controllerWeekly  = AnimationController(vsync: this, duration: const Duration(seconds: 1), value: 0.25);
    controllerMonthly = AnimationController(vsync: this, duration: const Duration(seconds: 1), value: 0.67);
    controllerTotal   = AnimationController(vsync: this, duration: const Duration(seconds: 1), value: 0.91);
    // _goalsFuture = DatabaseHelper.instance.getGoal();
    
    // Initialize all goals as unchecked
    for (var goal in dailyGoals) {
      dailyGoalsChecked[goal] = false;
    }
    for (var goal in weeklyGoals) {
      weeklyGoalsChecked[goal] = false;
    }
    for (var goal in monthlyGoals) {
      monthlyGoalsChecked[goal] = false;
    }
  }

  // void _refreshGoals() {
  //   setState(() {
  //     _goalsFuture = DatabaseHelper.instance.getGoal();
  //   });
  // }
  
  // Calculate progress based on checked goals
  void _updateProgress() {
    // Count checked goals
    int dailyChecked = dailyGoalsChecked.values.where((checked) => checked).length;
    int weeklyChecked = weeklyGoalsChecked.values.where((checked) => checked).length;
    int monthlyChecked = monthlyGoalsChecked.values.where((checked) => checked).length;
    
    // Calculate progress percentages
    double dailyProgress = dailyGoals.isEmpty ? 0 : dailyChecked / dailyGoals.length;
    double weeklyProgress = weeklyGoals.isEmpty ? 0 : weeklyChecked / weeklyGoals.length;
    double monthlyProgress = monthlyGoals.isEmpty ? 0 : monthlyChecked / monthlyGoals.length;
    
    // Calculate total progress
    int totalChecked = dailyChecked + weeklyChecked + monthlyChecked;
    int totalGoals = dailyGoals.length + weeklyGoals.length + monthlyGoals.length;
    double totalProgress = totalGoals == 0 ? 0 : totalChecked / totalGoals;
    
    // Animate to new values
    controllerDaily.animateTo(dailyProgress);
    controllerWeekly.animateTo(weeklyProgress);
    controllerMonthly.animateTo(monthlyProgress);
    controllerTotal.animateTo(totalProgress);
  }

  @override
  void dispose() {
    controllerDaily.dispose();
    controllerWeekly.dispose();
    controllerMonthly.dispose();
    controllerTotal.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double contentWidth = MediaQuery.of(context).size.width - 60;
    
    return Scaffold(
      backgroundColor: HiveColors.background,
      appBar: TopAppBar(title: "Goals"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            Container(
              width: contentWidth,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(30)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCircularProgress(
                        '${(controllerDaily.value * 100).toInt()}%', 
                        controllerDaily.value, 
                        HiveColors.yellow, 
                        'Daily Progress'
                      ),
                      _buildCircularProgress(
                        '${(controllerWeekly.value * 100).toInt()}%', 
                        controllerWeekly.value, 
                        HiveColors.bronze, 
                        'Weekly Progress'
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildLinearProgress('Monthly Progress', controllerMonthly.value, HiveColors.yellow),
                  const SizedBox(height: 15),
                  _buildLinearProgress('Total Completed Goals', controllerTotal.value, HiveColors.bronze),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daily Goals',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 32),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...dailyGoals.map((goal) => _buildGoalItem(
              goal, 
              contentWidth, 
              dailyGoalsChecked[goal] ?? false,
              (value) {
                setState(() {
                  dailyGoalsChecked[goal] = value ?? false;
                  _updateProgress();
                });
              }
            )).toList(),
            const SizedBox(height: 20),
            // Weekly Goals Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Weekly Goals',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 32),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...weeklyGoals.map((goal) => _buildGoalItem(
              goal, 
              contentWidth, 
              weeklyGoalsChecked[goal] ?? false,
              (value) {
                setState(() {
                  weeklyGoalsChecked[goal] = value ?? false;
                  _updateProgress();
                });
              }
            )).toList(),
            const SizedBox(height: 20),
            // Monthly Goals Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Monthly Goals',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 32),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...monthlyGoals.map((goal) => _buildGoalItem(
              goal, 
              contentWidth, 
              monthlyGoalsChecked[goal] ?? false,
              (value) {
                setState(() {
                  monthlyGoalsChecked[goal] = value ?? false;
                  _updateProgress();
                });
              }
            )).toList(),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress(String text, double value, Color color, String label) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(width: 120, height: 120, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            SizedBox(
              width: 90,
              height: 90,
              child: CircularProgressIndicator(value: value, strokeWidth: 36, backgroundColor: Colors.white, color: color),
            ),
            Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle)),
            Text(text, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLinearProgress(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(value: value, minHeight: 20, backgroundColor: Colors.white, color: color, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(width: 10),
            Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildGoalItem(String goal, double width, bool isChecked, Function(bool?) onChanged) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(30)),
      child: ListTile(
        leading: Checkbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor: HiveColors.yellow,
        ),
        title: Text(
          goal, 
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            decoration: isChecked ? TextDecoration.lineThrough : null,
          )
        ),
      ),
    );
  }
}