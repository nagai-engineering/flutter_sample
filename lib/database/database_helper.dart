import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL,
        completed INTEGER NOT NULL,
        date TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // Create a new task
  Future<Task> createTask(Task task) async {
    final db = await database;
    final id = await db.insert('tasks', task.toMap());
    return task.copyWith(id: id);
  }

  // Read all tasks
  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final result = await db.query('tasks', orderBy: 'created_at ASC');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  // Read tasks by date
  Future<List<Task>> getTasksByDate(String date) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'created_at ASC',
    );
    return result.map((map) => Task.fromMap(map)).toList();
  }

  // Update a task
  Future<int> updateTask(Task task) async {
    final db = await database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete a task
  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete tasks by date
  Future<int> deleteTasksByDate(String date) async {
    final db = await database;
    return db.delete(
      'tasks',
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  // Update task date (for moving tomorrow's tasks to today)
  Future<int> updateTaskDate(String oldDate, String newDate) async {
    final db = await database;
    return db.update(
      'tasks',
      {'date': newDate},
      where: 'date = ?',
      whereArgs: [oldDate],
    );
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
