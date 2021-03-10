import 'dart:io';
import 'package:ekta/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  DB._();
  static final DB db = DB._();

  static Database _database;

  String userTable = 'User';
  // String columnId = 'id';
  // String columnName = 'name';

  static final columnId = 'id';
  static final columnUserId = 'userId';
  static final columnRef = 'ref';
  static final columnDate = 'date';
  static final columnTimeStart= 'time_start';

  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'User.db';
    return await openDatabase(path, version: 2, onCreate: _createDB);
  }
  void _createDB(Database db, int version) async {
    // await db.execute(
    //   'CREATE TABLE $userTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT)',
    // );
    await db.execute('''
          CREATE TABLE $userTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUserId INTEGER NOT NULL,
            $columnRef TEXT NOT NULL,
            $columnDate INTEGER,
            $columnTimeStart INTEGER
          )
          ''');
  }

  // READ
  Future<List<User>> getUser() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> userMapList = await db.query(userTable);
    final List<User> userList = [];
    userMapList.forEach((userMap) {
      userList.add(User.fromMap(userMap));
    });
    return userList;
  }

  // INSERT
  Future<User> insertUser(User user) async {
    Database db = await this.database;
    user.id = await db.insert(userTable, user.toMapI());
    return user;
  }

  // UPDATE
  Future<int> updateUser(User user) async {
    Database db = await this.database;
    return await db.update(
      userTable,
      user.toMap(),
      where: '$columnId = ?',
      whereArgs: [user.id],
    );
  }

  // DELETE
  Future<int> deleteUser(int id) async {
    Database db = await this.database;
    return await db.delete(
      userTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}

// class DB {
//
//   static final _databaseName = "UserDB.db";
//   static final _databaseVersion = 1;
//
//   static final table = 'user';
//
//   static final columnId = '_id';
//   static final columnUserId = '_user_id';
//   static final columnRef = '_ref';
//   static final columnDate = 'date';
//   static final columnTimeStart= 'time_start';
//
//   // make this a singleton class
//   DB._privateConstructor();
//   static final DB instance = DB._privateConstructor();
//
//   // only have a single app-wide reference to the database
//   static Database _db;
//   Future<Database> get database async {
//     if (_db != null) return _db;
//     // lazily instantiate the db the first time it is accessed
//     _db = await _initDatabase();
//     return _db;
//   }
//
//   // this opens the database (and creates it if it doesn't exist)
//   _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _databaseName);
//     return await openDatabase(path,
//         version: _databaseVersion,
//         onCreate: _onCreate);
//   }
//
//   // SQL code to create the database table
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//           CREATE TABLE $table (
//             $columnId INTEGER PRIMARY KEY,
//             $columnUserId INTEGER NOT NULL,
//             $columnRef TEXT NOT NULL,
//             $columnDate INTEGER,
//             $columnTimeStart INTEGER
//           )
//           ''');
//   }
//
//   Future<int> insert(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     return await db.insert(table, row);
//   }
//
//   // newUser(User newUser) async {
//   //   final db = await database;
//   //   var res = await db.rawInsert(
//   //       "INSERT Into user (_user_id,_ref,date)"
//   //           " VALUES (${newUser.userId},${newUser.ref},${newUser.date}) returning user_id;");
//   //   return res;
//   // }
//   // updateUser(User newUser) async {
//   //   final db = await database;
//   //   var res = await db.update("user", newUser.toMap(),
//   //       where: "id = ?", whereArgs: [newUser.id]);
//   //   return res;
//   //}
//   // newClient(Client newClient) async {
//   //   final db = await database;
//   //   var res = await db.insert("Client", newClient.toMap());
//   //   return res;
//   // }
//   // getAllUser() async {
//   //   final db = await database;
//   //   var res = await db.query("user");
//   //   List<User> list =
//   //   res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
//   //   return list;
//   // }
//   deleteAll() async {
//     final db = await database;
//     db.rawDelete("Delete * from user");
//   }
//
//   Future<List<Map<String, dynamic>>> queryAllRows() async {
//     Database db = await instance.database;
//     return await db.query(table);
//   }
//
//   Future<List<Map<String, dynamic>>> queryLastRow() async {
//     Database db = await instance.database;
//     return await db.rawQuery('SELECT * FROM $table ORDER BY $columnId DESC LIMIT 1');
//   }
//
//
//   Future<int> queryRowCount() async {
//     Database db = await instance.database;
//     return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(_id) FROM $table'));
//   }
//
//   Future<int> update(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     int id = row[columnId];
//     return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
//   }
//
//   Future<int> delete(int id) async {
//     Database db = await instance.database;
//     return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
//   }
// }