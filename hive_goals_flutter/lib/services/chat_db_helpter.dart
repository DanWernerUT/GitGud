import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class ChatDBHelper {
  static final ChatDBHelper instance = ChatDBHelper._init();
  static Database? _database;
  
  ChatDBHelper._init();
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat.db');
    return _database!;
  }
  
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
    );
  }
  
  Future _createDB(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE contacts(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL
    )
    ''');

    await db.execute(''' 
    CREATE TABLE messages(
      id TEXT PRIMARY KEY,
      contact_id TEXT NOT NULL,
      content TEXT NOT NULL,
      timestamp TEXT NOT NULL,
      is_sent_by_me INTEGER NOT NULL,
      is_read INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (contact_id) REFERENCES contacts (id) ON DELETE CASCADE
    )
    ''');
  }
  
  // Contact methods
  Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await database;

    final contacts = await db.rawQuery('''
    SELECT 
      c.id, 
      c.name, 
      m.content as last_message,
      (SELECT COUNT(*) FROM messages 
       WHERE contact_id = c.id AND is_read = 0 AND is_sent_by_me = 0) as unread_count
    FROM contacts c
    LEFT JOIN (
      SELECT contact_id, content, timestamp 
      FROM messages 
      GROUP BY contact_id
      HAVING MAX(timestamp)
    ) m ON c.id = m.contact_id
    ORDER BY unread_count DESC, m.timestamp DESC
    ''');

    return contacts;
  }
  
  Future<String> addContact(String name) async {
    final db = await database;
    final id = Uuid().v4();

    await db.insert('contacts', {
      'id': id,
      'name': name,
    });

    return id;
  }
  
  // Message methods
  Future<List<Map<String, dynamic>>> getMessages(String contactId) async {
    final db = await database;

    final messages = await db.query(
      'messages',
      where: 'contact_id = ?',
      whereArgs: [contactId],
      orderBy: 'timestamp ASC',
    );

    return messages;
  }
  
  Future<void> sendMessage(String contactId, String content, DateTime timestamp) async {
    final db = await database;
    final id = Uuid().v4();

    await db.insert('messages', {
      'id': id,
      'contact_id': contactId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'is_sent_by_me': 1,
      'is_read': 1,
    });
  }
  
  Future<void> receiveDummyMessage(String contactId, String content) async {
    final db = await database;
    final id = Uuid().v4();

    await db.insert('messages', {
      'id': id,
      'contact_id': contactId,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
      'is_sent_by_me': 0,
      'is_read': 0,
    });
  }
  
  Future<void> markMessagesAsRead(String contactId) async {
    final db = await database;

    await db.update(
      'messages',
      {'is_read': 1},
      where: 'contact_id = ? AND is_sent_by_me = 0',
      whereArgs: [contactId],
    );
  }

  // New Methods to Clear Data
  // Clear all contacts from the database
  Future<void> clearContacts() async {
    final db = await database;

    await db.delete('contacts'); // Clears all records in the contacts table
  }

  // Clear all messages from the database
  Future<void> clearMessages() async {
    final db = await database;

    await db.delete('messages'); // Clears all records in the messages table
  }
  
  // Close database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
