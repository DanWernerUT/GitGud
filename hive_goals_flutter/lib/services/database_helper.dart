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
      version: 2,  // Increment when making schema changes
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE goal(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        text TEXT NOT NULL,
        tags TEXT,
        duration INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE goal ADD COLUMN name TEXT;");
      await db.execute("ALTER TABLE goal ADD COLUMN text TEXT;");
      await db.execute("ALTER TABLE goal ADD COLUMN tags TEXT;");
      await db.execute("ALTER TABLE goal ADD COLUMN duration INTEGER;");
    }
  }

  Future<List<Goal>> getGoals() async {
    Database db = await instance.database;
    var goalList = await db.query('goal', orderBy: 'name');
    return goalList.isNotEmpty
      ? goalList.map((c) => Goal.fromMap(c)).toList()
      : [];
  }

  Future<int> addGoal(Goal goal) async {
    Database db = await instance.database;
    return await db.insert('goal', goal.toMap());
  }

  Future<int> removeGoal(int id) async {
    Database db = await instance.database;
    return await db.delete('goal', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateGoal(Goal goal) async {
    Database db = await instance.database;
    return await db.update('goal', goal.toMap(), where: 'id = ?', whereArgs: [goal.id]);
  }
}
