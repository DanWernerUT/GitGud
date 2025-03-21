import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/models/goal_model.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/services/database_helper.dart';
// import 'package:hive_goals_flutter/widgets/bottom_nav.dart';
// import 'package:hive_goals_flutter/pages/goals.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController = TextEditingController();
  int? selectedId;
  int _selectedIndex = 2;
  late Future<List<Goal>> _goalsFuture;

  @override
  void initState() {
    super.initState();
    _goalsFuture = DatabaseHelper.instance.getGoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HiveColors.background,
      appBar: AppBar(
        backgroundColor: HiveColors.platinum,
        title: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: 'Enter Goal'),
        ),
      ),
      // body: _buildScreenForIndex(_selectedIndex),
      // bottomNavigationBar: BottomNavBar(
      //   currentIndex: _selectedIndex,
      //   onTap: _onTabTapped,
      // ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () async {
      //     if (textController.text.isNotEmpty) {
      //       if (selectedId != null) {
      //         await DatabaseHelper.instance.update(
      //           Goal(id: selectedId, name: textController.text, text: textController.text),
      //         );
      //       } else {
      //         await DatabaseHelper.instance.add(
      //           Goal(name: textController.text, text: textController.text),
      //         );
      //       }
      //       _refreshGoals();
      //       textController.clear();
      //       selectedId = null;
      //     }
      //   },
      // ),
    );
  }

  // Widget _buildScreenForIndex(int index) {
  //   switch (index) {  
  //     case 0:
  //       return Center(child: Text('Connections Page'));
  //     case 1:
  //       return Center(child: Text('Messages Page'));
  //     case 2:
  //       return _buildGoalList();
  //       // return Center(child: Text('Home Page'));
  //     case 3:
  //       return Center(child: Text('Calendar'));
  //     case 4:
  //       return Center(child: Text('View Calendar'));
  //     case 5:
  //       return Center(child: Text('Create Event'));
  //     case 6:
  //       return Center(child: Text('Goals'));
  //     case 7:
  //       return Center(child: Text('Create Goal'));
  //     case 8:
  //       Navigator.push(context,MaterialPageRoute(builder: (context) => UserGoalPage()),);
  //       return Center(child: Text('View Goals'));
  //     default:
  //       return Center(child: Text('Unknown Screen'));
  //   }
  // }

  // Widget _buildGoalList() {
  //   return FutureBuilder<List<Goal>>(
  //     future: _goalsFuture,
  //     builder: (BuildContext context, AsyncSnapshot<List<Goal>> snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(child: CircularProgressIndicator());
  //       }
  //       if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //         return Center(child: Text(''));
  //       }
        
  //       return ListView.builder(
  //         itemCount: snapshot.data!.length,
  //         itemBuilder: (context, index) {
  //           final goal = snapshot.data![index];
  //           return Card(
  //             color: selectedId == goal.id ? Colors.white70 : Colors.white,
  //             child: ListTile(
  //               title: Text(goal.name),
  //               onTap: () {
  //                 setState(() {
  //                   textController.text = goal.name;
  //                   selectedId = goal.id;
  //                 });
  //               },
  //               onLongPress: () async {
  //                 await DatabaseHelper.instance.remove(goal.id!);
  //                 _refreshGoals();
  //               },
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}