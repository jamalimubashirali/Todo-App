import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'todo.dart';

class TodoDatabase {
  static const _dbName = "todo.db";
  static const _tableName = "todos";
  static const _columnId = "id";
  static const _columnTitle = "title";
  static const _columnDesc = "description";
  static const _columnDate = "date";

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) {
        db.execute("""CREATE TABLE $_tableName (
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $_columnTitle TEXT NOT NULL,
        $_columnDesc TEXT NOT NULL,
        $_columnDate TEXT NOT NULL
        )""");
      },
      version: 1,
    );
    return db;
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    final todoMaps = await db.query(_tableName);
    List<Todo> todos = [];
    for (var map in todoMaps) {
      Todo todo = Todo.fromMap(map);
      todos.add(todo);
    }
    return todos;
  }

  insertTodo(Todo todo) async {
    final db = await database;
    await db.insert(
      _tableName,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  updateTodo(Todo todo) async {
    final db = await database;
    await db.update(
      _tableName,
      todo.toMap(),
      where: "$_columnId = ?",
      whereArgs: [todo.id],
    );
  }

  deleteTodo(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: "$_columnId = ?",
      whereArgs: [id],
    );
  }

  deleteAll() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
