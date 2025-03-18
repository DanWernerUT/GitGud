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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: TextField(
            controller: textController,
          ),
        ),
        body: Center(
          child: FutureBuilder<List<Goal>>(
            future: DatabaseHelper.instance.getGoal(),
            builder: (BuildContext context, AsyncSnapshot<List<Goal>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              return snapshot.data!.isEmpty
                ? Center(child: Text('No Goal in List.'))
                : ListView(
                  children: snapshot.data!.map((grocery) {
                    return Center(
                      child: Card(
                          color: selectedId == grocery.id
                          ? Colors.white70
                          : Colors.white, 
                        child: ListTile( 
                          title: Text(grocery.name),
                          onTap: () {
                            setState(() {
                              textController.text = grocery.name;
                              selectedId = grocery.id;
                            });
                          },
                          onLongPress: () {
                            setState(() {
                              DatabaseHelper.instance.remove(grocery.id!);
                            });
                          }, 
                        ),
                      ),
                    );
                  }).toList(),
                ); 
              }
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () async {
        //     selectedId != null
        //       ? await DatabaseHelper.instance.update(
        //       Goal(id: selectedId, name: textController.text),
        //     )
        //       : await DatabaseHelper.instance.add(
        //       Goal(name: textController.text),
        //     );
        //     setState(() {
        //       textController.clear();
        //     });
        //   },
        // ),
      )
    );
  }
}



