import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/widgets/top_nav.dart';

class CreateGoalPage extends StatefulWidget {
  @override
  _CreateGoalPageState createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends State<CreateGoalPage> {
  bool daily = false;
  bool weekly = false;
  bool monthly = false;
  bool custom = false;

  @override
  Widget build(BuildContext context) {
    double contentWidth = MediaQuery.of(context).size.width - 60;
    return Scaffold(
      backgroundColor: HiveColors.background,
      appBar: TopAppBar(title: "Create Goal"),
    );
  }

  Widget _goalCategory(String title, {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.yellow : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(title, style: TextStyle(color: Colors.black)),
    );
  }
  //   return Scaffold(
  //     backgroundColor: HiveColors.background,
  //     appBar: AppBar(
  //       backgroundColor: Colors.transparent,
  //       elevation: 0,
  //       title: Text(
  //         "Create Goal",
  //         style: TextStyle(color: Colors.white, fontSize: 24),
  //       ),
  //       centerTitle: true,
  //       iconTheme: IconThemeData(color: Colors.white),
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Wrap(
  //             spacing: 8.0,
  //             runSpacing: 8.0,
  //             children: [
  //               _goalCategory("Education"),
  //               _goalCategory("Fitness"),
  //               _goalCategory("Mind"),
  //               _goalCategory("Career"),
  //               _goalCategory("Family"),
  //               _goalCategory("Financial"),
  //               _goalCategory("Spiritual"),
  //               _goalCategory("Social"),
  //               _goalCategory("Health", isSelected: true),
  //             ],
  //           ),
  //           SizedBox(height: 20),
  //           Text("Goal Name:", style: TextStyle(color: Colors.white)),
  //           TextField(
  //             decoration: InputDecoration(
  //               hintText: "Go to the Gym 3x",
  //               filled: true,
  //               fillColor: Colors.white,
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           Text("Start:", style: TextStyle(color: Colors.white)),
  //           _dateField("March 10, 2025"),
  //           SizedBox(height: 10),
  //           Text("End:", style: TextStyle(color: Colors.white)),
  //           _dateField("March 10, 2026"),
  //           SizedBox(height: 20),
  //           Text("Repeat:", style: TextStyle(color: Colors.white)),
  //           Row(
  //             children: [
  //               _checkbox("Daily", daily, (value) => setState(() => daily = value!)),
  //               _checkbox("Weekly", weekly, (value) => setState(() => weekly = value!)),
  //             ],
  //           ),
  //           Row(
  //             children: [
  //               _checkbox("Monthly", monthly, (value) => setState(() => monthly = value!)),
  //               _checkbox("Custom", custom, (value) => setState(() => custom = value!)),
  //             ],
  //           ),
  //           Spacer(),
  //           Center(
  //             child: ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.yellow,
  //                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
  //               ),
  //               onPressed: () {},
  //               child: Text("Create Goal", style: TextStyle(color: Colors.black, fontSize: 16)),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _goalCategory(String title, {bool isSelected = false}) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: isSelected ? Colors.yellow : Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Text(title, style: TextStyle(color: Colors.black)),
  //   );
  // }

  // Widget _dateField(String text) {
  //   return Container(
  //     padding: EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Text(text, style: TextStyle(color: Colors.black)),
  //   );
  // }

  // Widget _checkbox(String label, bool value, Function(bool?) onChanged) {
  //   return Row(
  //     children: [
  //       Checkbox(value: value, onChanged: onChanged, activeColor: Colors.yellow),
  //       Text(label, style: TextStyle(color: Colors.white)),
  //     ],
    // );
  
}
