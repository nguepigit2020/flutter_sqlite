import 'dart:io';
import 'package:flutter_app_sqlite/models/contact.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static const _databaseName = 'ContactData.db';
  static const _databaseVersion = 1;

  //single class
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  Database _database;

 Future<Database> get database async{
   if(_database != null) return _database;
   _database = await initDatabase();
     return _database;
  }
  initDatabase()async{
   Directory dataDirectory = await getApplicationDocumentsDirectory();
   String dbPath = join(dataDirectory.path,_databaseName);
   return await openDatabase(dbPath,version: _databaseVersion,onCreate:_onCreateDB);
 }
  _onCreateDB(Database db,int version) async{
   await db.execute('''
     CREATE TABLE ${Contact.tblContact}(
     ${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
     ${Contact.colName} TEXT NOT NULL,
     ${Contact.colMobile} ITEXT NOT NULL
     )
    
   ''');
 }
  //contact - insert
  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return await db.insert(Contact.tblContact, contact.toMap());
  }
//contact - update
  Future<int> updateContact(Contact contact) async {
    Database db = await database;
    return await db.update(Contact.tblContact, contact.toMap(),
        where: '${Contact.colId}=?', whereArgs: [contact.id]);
  }
//contact - delete
  Future<int> deleteContact(int id) async {
    Database db = await database;
    return await db.delete(Contact.tblContact,
        where: '${Contact.colId}=?', whereArgs: [id]);
  }
//contact - retrieve all
  Future<List<Contact>> fetchContacts() async {
    Database db = await database;
    List<Map> contacts = await db.query(Contact.tblContact);
    return contacts.length == 0
        ? []
        : contacts.map((x) => Contact.fromMap(x)).toList();
  }
}