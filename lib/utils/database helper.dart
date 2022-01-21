import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_database_example/models/apartment_model.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'ApartmentDetail.db';
  static const _databaseVersion = 1;

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${ApartmentDetail.tblApartmentDetail}(
    ${ApartmentDetail.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${ApartmentDetail.colownerName} Text NOT NULL,
    ${ApartmentDetail.colphoneNumber} Text NOT NULL
    )
    ''');
  }

  Future<int> insertApartmentDetail(ApartmentDetail apartmentDetail) async {
    Database db = await _database!;
    return await db.insert(
      ApartmentDetail.tblApartmentDetail,
      apartmentDetail.toMap(),
    );
  }

  Future<int> updateApartmentDetail(ApartmentDetail apartmentDetail) async {
    Database db = await _database!;
    return await db.update(
        ApartmentDetail.tblApartmentDetail, apartmentDetail.toMap(),
        where: '${ApartmentDetail.colId}=?', whereArgs: [apartmentDetail.id]);
  }

  Future<int> deleteApartmentDetail(int id) async {
    Database db = await _database!;
    return await db.delete(ApartmentDetail.tblApartmentDetail,
        where: '${ApartmentDetail.colId}=?', whereArgs: [id]);
  }

  Future<List<ApartmentDetail>> fetchApartmentDetails() async {
    Database db = await database;
    List<Map> apartmentDetails =
        await db.query(ApartmentDetail.tblApartmentDetail);
    return apartmentDetails.isEmpty
        ? []
        : apartmentDetails.map((e) => ApartmentDetail.fromMap(e)).toList();
  }
}
