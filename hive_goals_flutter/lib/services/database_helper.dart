import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:hive_goals_flutter/models/goal_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();  

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'goal.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE goal(
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');
  }
  Future<List<Goal>> getGoal() async {
    Database db = await instance.database;
    var goal = await db.query('goal', orderBy: 'name');
    List<Goal> goalList = goal.isNotEmpty
      ? goal.map((c) => Goal.fromMap(c)).toList()
      : [];
      return goalList;
  }

  Future<int> add(Goal goal) async {
    Database db = await instance.database;
    return await db.insert('goal', goal.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('goal', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Goal goal) async {
    Database db = await instance.database;
    return await db.update('goal', goal.toMap(), where: 'id = ?', whereArgs: [goal.id]);
  }
}