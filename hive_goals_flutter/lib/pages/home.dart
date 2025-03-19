import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/models/goal_model.dart';
import 'package:hive_goals_flutter/services/database_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: 'Enter Goal'),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Goal>>(
          future: _goalsFuture,
          builder: (BuildContext context, AsyncSnapshot<List<Goal>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Goals in List.'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final goal = snapshot.data![index];
                return Card(
                  color: selectedId == goal.id ? Colors.white70 : Colors.white,
                  child: ListTile(
                    title: Text(goal.name),
                    onTap: () {
                      setState(() {
                        textController.text = goal.name;
                        selectedId = goal.id;
                      });
                    },
                    onLongPress: () async {
                      await DatabaseHelper.instance.remove(goal.id!);
                      _refreshGoals(); // Refresh the list after deletion
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          if (textController.text.isNotEmpty) {
            if (selectedId != null) {
              await DatabaseHelper.instance.update(
                Goal(id: selectedId, name: textController.text, text: textController.text),
              );
            } else {
              await DatabaseHelper.instance.add(
                Goal(name: textController.text, text: textController.text),
              );
            }
            _refreshGoals();
            textController.clear();
            selectedId = null;
          }
        },
      ),
    );
  }
}
