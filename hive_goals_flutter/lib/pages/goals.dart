import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/models/goal_model.dart';
// import 'package:hive_goals_flutter/models/user_model.dart';
import 'package:hive_goals_flutter/services/database_helper.dart';
// import 'package:hive_goals_flutter/res/hive_colors.dart';

class UserGoalPage extends StatefulWidget {
  const UserGoalPage({super.key});

  @override
  State<UserGoalPage> createState() => _UserGoalPageState();
}

class _UserGoalPageState extends State<UserGoalPage> {
  final textController = TextEditingController();
  int? selectedId;
  late Future<List<Goal>> _goalsFuture;

  @override
  void initState() {
    super.initState();
    _goalsFuture = DatabaseHelper.instance.getGoal();
  }

  void _refreshGoals() {
    setState(() {
      _goalsFuture = DatabaseHelper.instance.getGoal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}