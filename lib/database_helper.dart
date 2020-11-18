import 'dart:async';
import 'package:CRUDPassagaem/passagem.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;
  DatabaseHelper.internal();
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE passagem(id INTEGER PRIMARY KEY,nome TEXT, partida TEXT, destino TEXT, classe TEXTO)');
  }

  Future<int> inserirPassagem(Passagem passagem) async {
    var dbClient = await db;
    var result = await dbClient.insert("passagem", passagem.toMap());
    return result;
  }

  Future<List> getPassagens() async {
    var dbClient = await db;
    var result = await dbClient
        .query("passagem", columns: ["id", "nome", "partida", "destino", "classe"]);
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM passagem'));
  }

  Future<Passagem> getPassagem(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query("passagem",
        columns: ["id", "nome", "partida", "destino", "classe"],
        where: 'ide = ?',
        whereArgs: [id]);
    if (result.length > 0) {
      return new Passagem.fromMap(result.first);
    }
    return null;
  }

  Future<int> deletePassagem(int id) async {
    var dbClient = await db;
    return await dbClient.delete("passagem", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updatePassagem(Passagem passagem) async {
    var dbClient = await db;
    return await dbClient.update("passagem", passagem.toMap(),
        where: "id = ?", whereArgs: [passagem.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
