
import 'package:flutter/foundation.dart';
import 'package:notescribe/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;


class DBHelper{
  static Database? _db;
  final String _tableName = "notes" ;

  Future<Database> get db async{
    if(_db != null){
      return _db!;
    }

    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');  //databse path name
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);

    return db;
  }

  _onCreate(Database db, int version) async{
    await db.execute(
      "CREATE TABLE $_tableName("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "title STRING, plainText TEXT ,description TEXT, createdTime STRING, "
      "category STRING,"
      "links TEXT,"          
      "images TEXT,"
      "isImportant INTEGER)",
    );
  }

  //^ to add 
  Future<Note> insert(Note? note) async{
    var dbClient = await db ;

    await dbClient.insert(_tableName, note!.toMap());
    return note; 
  }

  //^ to fetch all
  Future<List<Note>> getNotesList() async {
    if (kDebugMode) {
        print("note list is fetching...");
    }
    var dbClient = await db ;
    final List<Map<String, Object?>> queryResult = await dbClient!.query(_tableName) ;

    return queryResult.map((e) => Note.fromMap(e)).toList();
  }

  //^ to fetch by category
  Future<List<Note>> getCategoryNotesList(String category) async {
    if (kDebugMode) {
        print("note list is fetching...");
    }
    var dbClient = await db ;
    final List<Map<String, Object?>> queryResult = await dbClient!.query(
      _tableName,
      where: 'category = ?',
      whereArgs: [category]
    ) ;

    return queryResult.map((e) => Note.fromMap(e)).toList();
  }

  //^ to update
  Future<int> update(Note? note) async{
    var dbClient = await db ;

    return await dbClient.update(
      _tableName, 
      note!.toMap(),
      where: 'id = ?',
      whereArgs: [note.id]
    );
  }

  //^ to delete
  Future<int> delete(int id) async{
    var dbClient = await db ;
    return await dbClient!.delete(_tableName, where: 'id=?' , whereArgs: [id]);
  }

}

// class DBHelper{
//   static Database? _db;
//   static final int _version =1;
//   static final String _tableName = "notes";

//   static Future<void> initDb() async{

//     if(_db != null){   //ie. it already been initialize
//       return;
//     }
//     try{
//       String _path = await getDatabasesPath() + 'notes.db';    //database is created
//       _db = await openDatabase(
//         _path,
//         version: _version,
//         onCreate: (db, version){
//           if (kDebugMode) {
//             print("creating a new one");
//           }
//           return db.execute(     //table is created in database
              // "CREATE TABLE $_tableName("
              // "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              // "title STRING, note TEXT, date STRING, "
              // "startTime STRING, endTime STRING, "
              // "remind INTEGER, repeat STRING, "
              // "color INTEGER, "
              // "isCompleted INTEGER)",
//           );
//         }
//       );
//     } catch(e){
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }

//   static Future <int> insert(Note? note) async{
//     return await _db?.insert( _tableName, note!.toJson() )??1;  //1 is random number
//   }
  
//   static Future<List<Map<String, dynamic>>> query() async {
//     if (kDebugMode) {
//         print("query function called");
//       }
//     return await _db!.query(_tableName);
//   }

//   static delete(Note note)async{
//     return await _db!.delete(_tableName, where: 'id=?' , whereArgs: [note.id]);
//   }

  // static upadte(int id)async{
  //  return await _db!.rawUpdate(''' 
  //     UPDATE tasks
  //     SET isCompleted = ?
  //     WHERE id = ?
  //   ''', [1,id] );  //means set 1 to isCompleted of id coming
  // }



// }