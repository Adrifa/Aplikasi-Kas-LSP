
import 'package:aplikasikas_vero/UserModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'KasModel.dart';

class DatabaseHelper {
  static Database? _database;
  static const pengguna ='user'; // Inisialisasi dengan null

  Future<Database> get database async {
    if (_database != null)
      return _database!; // Gunakan _database jika sudah diinisialisasi

    _database = await _initDatabase();
    return _database!;
  }

  // ...



  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'aplikasikas.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT
          )
        ''');
        /*
        // Tambahkan pengguna default
        Map<String, dynamic> defaultUser = {
          'username': 'admin',
          'password': 'admin',
        };
        await db.insert('user', defaultUser);
*/
// Cek apakah tabel "user" sudah memiliki data
            List<Map<String, dynamic>> userCount = await db.query('user');
            if (userCount.isEmpty) {
              // Jika tabel "user" kosong, tambahkan data pengguna default
              Map<String, dynamic> defaultUser = {
                'username': 'admin',
                'password': 'admin',
              };
              await db.insert('user', defaultUser);
            }

          
        await db.execute('''
          CREATE TABLE kas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tanggal TEXT,
            nominal REAL,
            keterangan TEXT,
            status TEXT
          )
        ''');




      },
    );
  }

  Future<int> insertKas(KasModel kas) async {
    final Database db = await database;
    return await db.insert('kas', kas.toMap());
  }

  Future<int> deleteKas(int kasId) async {
    final Database db = await database;
    return await db.delete('kas', where: 'id = ?', whereArgs: [kasId]);
  }

  //total pemasukkan dengan status plus
  Future<double> getTotalPlus() async {
    final Database db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'kas',
      where: 'status = ?',
      whereArgs: ['plus'],
    );
    double totalPlus = 0.0;
    for (final Map<String, dynamic> result in results) {
      final double nominal = result['nominal'] as double;
      totalPlus += nominal;
    }
    return totalPlus;
  }

  //total pemasukkan dengan status plus
  Future<double> getTotalMin() async {
    final Database db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'kas',
      where: 'status = ?',
      whereArgs: ['min'],
    );
    double totalPlus = 0.0;
    for (final Map<String, dynamic> result in results) {
      final double nominal = result['nominal'] as double;
      totalPlus += nominal;
    }
    return totalPlus;
  }

  Future<List<KasModel>> getKasList() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('kas');
    return List.generate(maps.length, (i) {
      return KasModel(
        id: maps[i]['id'],
        tanggal: DateTime.parse(maps[i]['tanggal']),
        nominal: maps[i]['nominal'],
        keterangan: maps[i]['keterangan'],
        status: maps[i]['status'],
      );
    });
  }


  //chart



  //user
  Future<Map<String, dynamic>?> getUser(
      String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
       //return maps.first;
    }
  }
  Future<int> insertUser(UserModel user) async {
    final Database db = await database;
    return await db.insert('user', user.toMap());
  }


Future<int> updatePassword(String username, String newPassword) async {
    final db = await database;
    return await db.update(
      'user',
      {'password': newPassword},
      where: 'username = ?',
      whereArgs: [username],
    );
  }
}
