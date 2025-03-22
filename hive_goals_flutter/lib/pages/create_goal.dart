import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/res/hive_text.dart';
import 'package:hive_goals_flutter/widgets/top_nav.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/res/hive_style.dart';
import 'package:date_field/date_field.dart';
import 'package:hive_goals_flutter/services/app_state.dart';

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
  Set<String> selectedCategories = {}; // Default selected category

  @override
  Widget build(BuildContext context) {
    double contentWidth = MediaQuery.of(context).size.width - 60;
    return Scaffold(
      backgroundColor: HiveColors.background,
      appBar: TopAppBar(title: "Create Goal"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: contentWidth,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12.0,
                  runSpacing: 8.0,
                  children: [
                    goalCategory("Fitness"),
                    goalCategory("Mind"),
                    goalCategory("Career"),
                    goalCategory("Education"),
                    goalCategory("Family"),
                    goalCategory("Financial"),
                    goalCategory("Spiritual"),
                    goalCategory("Social"),
                    goalCategory("Health"),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintStyle: HiveStyle.lightBody.copyWith(color: HiveColors.darkPurple),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  hintText: "Goal Name",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              SizedBox(height: 20),
              DateTimeFormField(
                decoration: InputDecoration(
                  hintText: "Start Date",
                  hintStyle: HiveStyle.lightBody.copyWith(color: HiveColors.darkPurple),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  suffixIcon: Padding(padding: EdgeInsets.only(right: 20), child: Icon(Icons.calendar_today)),
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  suffixIcon: Padding(padding: EdgeInsets.only(right: 20), child: Icon(Icons.calendar_today)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onChanged: (DateTime? value) {
                  selectedStartDate = value;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  HiveText.boldBody("  Repeat  "),
                  _checkbox("", repeat, (bool? newValue) { 
                    setState(() { 
                      repeat = newValue!; 
                      if (!repeat) { daily = false; weekly = false; monthly = false; custom = false; } 
                    }); 
                  }),
                ],
              ),
              if (repeat) 
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _checkbox("Daily", daily, (bool? newValue) { 
                          setState(() { 
                            daily = newValue!;
                            if (daily) { weekly = false; monthly = false; custom = false; } 
                          }); 
                        })),
                        SizedBox(width: 20), // Adds space between checkboxes
                        Expanded(child: _checkbox("Weekly", weekly, (bool? newValue) { 
                          setState(() { 
                            weekly = newValue!;
                            if (weekly) { daily = false; monthly = false; custom = false; } 
                          }); 
                        })),
                      ],
                    ),
                    SizedBox(height: 10), // Space between rows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _checkbox("Monthly", monthly, (bool? newValue) { 
                          setState(() { 
                            monthly = newValue!;
                            if (monthly) { daily = false; weekly = false; custom = false; } 
                          }); 
                        })),
                        SizedBox(width: 20), // Adds space between checkboxes
                        Expanded(child: _checkbox("Custom", custom, (bool? newValue) { 
                          setState(() { 
                            custom = newValue!;
                            if (custom) { daily = false; weekly = false; monthly = false; } 
                          }); 
                        })),
                      ],
                    ),
                    if (custom) ...[
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Enter custom repeat interval",
                          hintStyle: HiveStyle.lightBody.copyWith(color: HiveColors.darkPurple),
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HiveColors.yellow,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  onPressed: () {AppState().changeTabCallback?.call(8);},
                  child: HiveText(title: "Create Goals", style: HiveStyle.boldBody.copyWith(color: HiveColors.darkPurple))
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged, activeColor: HiveColors.yellow),
        HiveText(title: label, style: HiveStyle.boldBody.copyWith(color: HiveColors.platinum)),
      ],
    );
  }

  Widget goalCategory(String title) {
    bool isSelected = selectedCategories.contains(title);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedCategories.remove(title);
          } else {
            selectedCategories.add(title);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? HiveColors.yellow : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: HiveText(title: title, style: HiveStyle.boldBody.copyWith(color: HiveColors.darkPurple))
      ),
    );
  }
}
