import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseHelper {

  SqfliteDatabaseHelper.internal();
  static final SqfliteDatabaseHelper instance = new SqfliteDatabaseHelper.internal();
  factory SqfliteDatabaseHelper() => instance;

  static final contactinfoTable = 'codigos';
  static final _version = 1;

  static Database ?_db;

  Future<Database> get db async {
    if (_db !=null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final caminhoBancoDeDados = await getDatabasesPath();
    final localBancoDeDados = join(caminhoBancoDeDados, "banco.db");

    var db = await openDatabase(
        localBancoDeDados,
        version: 1,
        onCreate: (db, dbVersaoRecente){
          String sql = "CREATE TABLE codigos (id INTEGER PRIMARY KEY AUTOINCREMENT, codigo VARCHAR, userId VARCHAR, status INTEGER)";
          db.execute(sql);
        }
    );
    return db;
  }
}