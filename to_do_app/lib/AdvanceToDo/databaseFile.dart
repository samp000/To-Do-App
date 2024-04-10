import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<dynamic> initialiseDatabase() async {
  if (Platform.isLinux) {
    databaseFactory = databaseFactoryFfi;

    return databaseFactory.openDatabase(
      p.join(await getDatabasesPath(), "ToDo.db"),
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: ((db, version) {
          db.execute('''
              CREATE TABLE UserData(
                id INTEGER PRIMARY KEY,
                name TEXT,
                mobileNo TEXT,
                password TEXT
                )''');

          db.execute('''
              CREATE TABLE ToDoTable(
                id INTEGER PRIMARY KEY,
                title TEXT,
                desc TEXT,
                date TEXT,
                completed INTEGER
                )''');
        }),
      ),
    );
  } else {
    return openDatabase(
      p.join(await getDatabasesPath(), "ToDo.db"),
      version: 1,
      onCreate: ((db, version) async {
        print("Path keySan ${p.join(await getDatabasesPath(), 'ToDo.db')}");

        db.execute(''' CREATE TABLE UserData (
                id INTEGER PRIMARY KEY,
                name TEXT,
                mobileNo TEXT,
                password TEXT
                )''');

        db.execute('''
              CREATE TABLE ToDoTable(
                id INTEGER PRIMARY KEY,
                title TEXT,
                desc TEXT,
                date TEXT,
                completed INTEGER
                )''');
      }),
    );
  }
}
