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
  late Future<List<Goal>> _goalsFuture;
  
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
    _goalsFuture = DatabaseHelper.instance.getGoal();
  }

  void _refreshGoals() {
    setState(() {
      _goalsFuture = DatabaseHelper.instance.getGoal();
    });
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: contentWidth,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCircularProgress('76%', controllerDaily.value, HiveColors.yellow, 'Daily Progress'),
                        _buildCircularProgress('25%', controllerWeekly.value, HiveColors.bronze, 'Weekly Progress'),
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
                  const Text(
                    'Weekly Goals'
                  ),
                    IconButton(
                    icon: const Icon(Icons.add, color: Colors.white, size: 32),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...dailyGoals.map((goal) => _buildGoalItem(goal, contentWidth)).toList(),
              const SizedBox(height: 60),
            ],
          ),
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

  Widget _buildGoalItem(String goal, double width) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(30)),
      child: ListTile(
        leading: Checkbox(value: false, onChanged: (value) {}),
        title: Text(goal, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
