import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HiveColors.background, // Background color
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "March",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "10, 2025",
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                ScheduleItem(
                  time: "8:30",
                  title: "Breakfast with Jane",
                  color: Color(0xFFD2A679),
                ),
                ScheduleItem(
                  time: "10:30",
                  title: "School",
                  color: Color(0xFFF7E69C),
                ),
                ScheduleItem(
                  time: "12:30",
                  title: "Lunch",
                  color: Color(0xFFD6D6D6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleItem extends StatelessWidget {
  final String time;
  final String title;
  final Color color;

  ScheduleItem({required this.time, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          "$time - $title",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
