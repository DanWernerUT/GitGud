import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/res/hive_text.dart';
import 'package:hive_goals_flutter/widgets/top_nav.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/res/hive_style.dart';
import 'package:date_field/date_field.dart';

class CreateGoalPage extends StatefulWidget {
  const CreateGoalPage({super.key});

  @override
  CreateGoalPageState createState() => CreateGoalPageState();
}

class CreateGoalPageState extends State<CreateGoalPage> {
  bool repeat = false;
  bool daily = false;
  bool weekly = false;
  bool monthly = false;
  bool custom = false;
  DateTime? selectedStartDate;

  @override
  Widget build(BuildContext context) {
    double contentWidth = MediaQuery.of(context).size.width - 60;
    return Scaffold(
      backgroundColor: HiveColors.background,
      appBar: TopAppBar(title: "Create Goal"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox (
              width: contentWidth,
              child:Column(
                children: [
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      goalCategory("Education"),
                      goalCategory("Fitness"),
                      goalCategory("Mind"),
                      goalCategory("Career"),
                      goalCategory("Family"),
                      goalCategory("Financial"),
                      goalCategory("Spiritual"),
                      goalCategory("Social"),
                      goalCategory("Health", isSelected: true),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                HiveText.boldBody("Repeat  "),
                _checkbox("", repeat, (bool? newValue) { setState(() { repeat = newValue!; if (!repeat) { daily = false; weekly = false; monthly = false; custom = false; } }); }),
              ],
            ),            
            if(repeat) ...[
              Column(
                children: [
                  Row(
                    children: [
                      _checkbox("Daily", daily, (bool? newValue) { setState(() { daily = newValue!; if (daily) { weekly = false; monthly = false; custom = false; } }); }),
                      SizedBox(width: 25),
                      _checkbox("Weekly", weekly, (bool? newValue) { setState(() { weekly = newValue!; if (weekly) { daily = false; monthly = false; custom = false; } }); }),
                    ],
                  ),
                  Row(
                    children: [
                      _checkbox("Monthly", monthly, (bool? newValue) { setState(() { monthly = newValue!; if (monthly) { daily = false; weekly = false; custom = false; } }); }),
                      _checkbox("Custom", custom, (bool? newValue) { setState(() { custom = newValue!; if (custom) { daily = false; weekly = false; monthly = false; } }); }),
                    ],
                  ),
                ],
              ),
            ],
            TextField(
              decoration: InputDecoration(
                hintText: "Goal Name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            DateTimeFormField(
              decoration: InputDecoration(
                hintText: "Start Date",
                hintStyle: HiveStyle.lightBody.copyWith(color: HiveColors.darkPurple),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                suffixIcon: Padding(padding: EdgeInsets.only(right: 20), child: Icon(Icons.calendar_today)),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onChanged: (DateTime? value) {
                selectedStartDate = value;
              },
            ),
            SizedBox(height: 20),
            DateTimeFormField(
              decoration: InputDecoration(
                hintText: "End Date",
                hintStyle: HiveStyle.lightBody.copyWith(color: HiveColors.darkPurple),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                suffixIcon: Padding(padding: EdgeInsets.only(right: 20), child: Icon(Icons.calendar_today)),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onChanged: (DateTime? value) {
                selectedStartDate = value;
              },
            ),
          ],
        ),
      )
    );
  }

  Widget _checkbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged, activeColor: Colors.yellow),
        HiveText(title: label, style: HiveStyle.boldBody.copyWith(color: HiveColors.platinum)),
      ],
    );
  }

  Widget goalCategory(String title, {bool isSelected = false}) {
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
  //       elevation: 0,r
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
