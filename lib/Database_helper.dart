import 'package:sqflite/sqflite.dart';
import 'Note.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //singleton
  static Database _database; //singleton

  String noteTable = 'note_table';
  String coldId = 'id';
  String colTitle = 'title';
  String coldDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($coldId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$coldDescription TEXT,$colPriority INTEGER,$colDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getNotesMapList() async {
    Database db = await this.database;
    //optional
    // var result=await db.rawQuery('select * from $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$coldId=?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $noteTable where $coldId=$id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNotList() async {
    var notemapList = await getNotesMapList();
    int count = notemapList.length;

    List<Note> noteList = List<Note>();

    for (var i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(notemapList[i]));
    }
    return noteList;
  }
}
