import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConnectionsDBHelper {
  static final ConnectionsDBHelper instance = ConnectionsDBHelper._init();
  static Database? _database;

  ConnectionsDBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("connections.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        category TEXT,
        comments INTEGER
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    final db = await instance.database;
    return await db.query('posts');
  }

  Future<void> addPost(String title, String description, String category, int comments) async {
    final db = await instance.database;
    await db.insert('posts', {
      'title': title,
      'description': description,
      'category': category,
      'comments': comments,
    });
  }

  Future<void> deletePost(int id) async {
    final db = await instance.database;
    await db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updatePost(int id, String title, String description, String category, int comments) async {
    final db = await instance.database;
    await db.update(
      'posts',
      {'title': title, 'description': description, 'category': category, 'comments': comments},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}