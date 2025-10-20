import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/note.dart';

class DatabaseHelper {
  // Singleton instance (ensures one database connection in the entire app)
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Factory constructor returns the same instance every time
  factory DatabaseHelper() => _instance;

  // 3. Private constructor prevents direct instantiation from outside.
  DatabaseHelper._internal();

  // Holds the database instance
  static Database? _database;

  // Getter that ensures the database is initialized once
  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  // Initializes the database
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            body TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // For future schema upgrades
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  // Inserts a note into the database
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  // Retrieves all notes, sorted by most recent
  Future<List<Note>> getNotes() async {
    final db = await database;
    final result = await db.query('notes', orderBy: 'id DESC');
    return result.map((e) => Note.fromMap(e)).toList();
  }

  // Retrieves a single note by its ID
  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final result = await db.query('notes', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Note.fromMap(result.first);
    }
    return null;
  }

  // Updates an existing note
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Deletes a note by ID
  Future<int> deleteNoteById(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // Closes the database connection safely
  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
    }
    _database = null;
  }
}
