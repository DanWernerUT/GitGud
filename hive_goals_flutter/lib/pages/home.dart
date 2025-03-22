import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/services/app_state.dart';
import 'package:hive_goals_flutter/widgets/top_nav.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double contentWidth = MediaQuery.of(context).size.width - 60;

    return Scaffold(
      backgroundColor: HiveColors.background,
      appBar: TopAppBar(title: "Welcome John"),
      body: Center(
        child: SizedBox(
          width: contentWidth,
          child: Column(
            children: [
              // Task List
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: List.generate(3, (index) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Checkbox(value: false, onChanged: (value) {}),
                          const Text("Get out of bed", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    );
                  }),
                ),
              ),

              // Grid for Goals, Calendar, Chat, Connect
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.2,
                    children: [
                      _gridItem(Icons.track_changes, "Goals", 8),
                      _gridItem(Icons.calendar_today, "Calendar", 4),
                      _gridItem(Icons.chat, "Chat", 1),
                      _gridItem(Icons.group, "Connect", 0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Grid Items with Navigation
  Widget _gridItem(IconData icon, String label, int tabIndex) {
    return InkWell(
      onTap: () {
        AppState().changeTabCallback?.call(tabIndex);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.black87),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
