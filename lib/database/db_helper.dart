import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:phonebook/model/Contact.dart';
class DbHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    var dbFolder = await getDatabasesPath();
    String path = join(dbFolder, "Contact.db");
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE table Contact(id INTEGER PRIMARY KEY, name TEXT, phone_number TEXT, avatar TEXT)");
  }

  Future<List<Contact>> getContacts() async {
    var dbClient = await db;
    var result = await dbClient.query("Contact", orderBy: "name");
    return result.map((data) => Contact.fromMap(data)).toList();
  }

  Future<int> insertContact(Contact contact) async {
    var dbClient = await db;
    return await dbClient.insert("Contact", contact.toMap());
  }

  Future<void> removeContact(int id) async {
    var dbClient = await db;
    return await dbClient.delete("Contact", where: "id=?", whereArgs: [id]);
  }
  Future<int> updateContact(Contact contact) async{
    var dbClient = await db;
    return await dbClient.update("Contact", contact.toMap(),where: "id=?", whereArgs: [contact.id]);
  }
}