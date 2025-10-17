import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  // secure storage
  // share preference
  // hive //
  // Riverpod
  // cubit, retrofit, hive, authentication

  // Lazily get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  // Initialize database with error handling and migration support
  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      // openDatabase automatically calls onCreate if DB doesn't exist,
      // and onUpgrade when the version changes.
      return await openDatabase(
        path,
        version: 2, // increment when schema changes
        onCreate: (db, version) async {
          log('Creating database at $path');
          await db.execute('''
            CREATE TABLE notes (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              body TEXT NOT NULL
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          log('Upgrading database from version $oldVersion to $newVersion');

          // Example migration logic
          if (oldVersion < 2) {
            // Suppose you want to add a "timestamp" column in version 2
            await db.execute('ALTER TABLE notes ADD COLUMN timestamp TEXT');
          }
        },
        onDowngrade: onDatabaseDowngradeDelete, // optional safety measure
      );
    } catch (e, stack) {
      log('Error initializing database: $e', stackTrace: stack);
      rethrow; // allow caller to handle if needed
    }
  }

  // Insert a note
  Future<int> insertNote(Note note) async {
    try {
      final db = await database;
      return await db.insert('notes', note.toMap());
    } catch (e, stack) {
      log('Error inserting note: $e', stackTrace: stack);
      return -1; // indicate failure
    }
  }

  // Get all notes
  Future<List<Note>> getNotes() async {
    try {
      final db = await database;
      final result = await db.query('notes', orderBy: 'id DESC');
      return result.map((e) => Note.fromMap(e)).toList();
    } catch (e, stack) {
      log('Error fetching notes: $e', stackTrace: stack);
      return [];
    }
  }

  // Get a single note by ID
  Future<Note?> getNoteById(int id) async {
    try {
      final db = await database;
      final result = await db.query('notes', where: 'id = ?', whereArgs: [id]);
      if (result.isNotEmpty) {
        return Note.fromMap(result.first);
      }
      return null;
    } catch (e, stack) {
      log('Error fetching note with id=$id: $e', stackTrace: stack);
      return null;
    }
  }

  // Update a note
  Future<int> updateNote(Note note) async {
    try {
      final db = await database;
      return await db.update(
        'notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
    } catch (e, stack) {
      log('Error updating note: $e', stackTrace: stack);
      return 0;
    }
  }

  // Delete a note
  Future<int> deleteNoteById(int id) async {
    try {
      final db = await database;
      return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    } catch (e, stack) {
      log('Error deleting note with id=$id: $e', stackTrace: stack);
      return 0;
    }
  }

  // Close the database connection
  Future<void> close() async {
    try {
      final db = _database;
      if (db != null && db.isOpen) {
        await db.close();
        log('Database closed successfully.');
      }
      _database = null;
    } catch (e, stack) {
      log('Error closing database: $e', stackTrace: stack);
    }
  }
}
