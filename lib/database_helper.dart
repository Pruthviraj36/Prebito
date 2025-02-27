import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'profile.dart'; // Assuming you have a Profile class

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'matrimony.db');
    return await openDatabase(
      path,
      version: 2, // Incremented database version
      onCreate: _onCreate,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE profiles ADD COLUMN isFavorite INTEGER DEFAULT 0");
        }
      },
    );
  }


  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE profiles(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      email TEXT,
      mobileNumber TEXT,
      age INTEGER,
      location TEXT,
      gender TEXT,
      hobbies TEXT,
      password TEXT,
      imagePath TEXT,
      dateOfBirth TEXT,
      isFavorite INTEGER DEFAULT 0
    )
  ''');
  }

  Future<void> insertProfile(Profile profile) async {
    final db = await database;
    await db.insert('profiles', profile.toMap());
  }

  Future<List<Profile>> getProfiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('profiles');
    return List.generate(maps.length, (i) {
      return Profile.fromMap(maps[i]);
    });
  }

  Future<void> updateProfile(Profile profile) async {
    final db = await database;
    int result = await db.update(
      'profiles',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );

    if (result == 0) {
      print('Update failed: No rows affected');
    } else {
      print('Update successful: $result rows updated');
    }
  }


  Future<void> deleteProfile(int id) async {
    final db = await database;
    await db.delete(
      'profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}