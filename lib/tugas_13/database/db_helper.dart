import 'package:daftar_siswa_app/tugas_13/models/student_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:daftar_siswa_app/tugas_13/models/user_model.dart';
   
class DBHelper {
  static Database? _database;

  // Initialize database
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'daftar_siswa.db'),
      onCreate: (db, version) async {
        // Create the 'anggota_baru' table
        await db.execute('''
          CREATE TABLE anggota_baru(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            nama TEXT, 
            email TEXT, 
            visimisi TEXT, 
            phone TEXT
          )
        ''');  
        // Create the 'users' table for login/registration
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT, 
            username TEXT, 
            email TEXT UNIQUE, 
            phone TEXT, 
            password TEXT
          )
        ''');
      },
      // onUpgrade is intentionally omitted as per your request
      version: 1, // Database version
    );
  }

  // dipakai untuk proses autentikasi/login user dengan memeriksa email dan password pada db 

  static Future<UserModel?> login(String email, String password) async {
    final db = await initDB();
    final List<Map<String, dynamic>> data = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (data.isNotEmpty) {
      return UserModel.fromMap(data.first);
    } else {
      return null;
    }
  }

  static Future<void> registerUser({UserModel? data}) async {
    if (data == null) {
      print("Error: User data is null for registration.");
      return;
    }
    final db = await initDB();

    await db.insert('users', {
      'name': data.name,
      'username': data.username,
      'email': data.email,
      'phone': data.phone,
      'password': data.password,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    print("User registered successfully");
  }

  // --- Anggota Baru (Student Member) Methods ---

  // CREATE: Add new anggota
  static Future<void> insertAnggota(StudentModel anggota) async {
    final db = await database;
    await db.insert(
      'anggota_baru',
      anggota.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Anggota inserted successfully: ${anggota.nama}");
  }

  // READ: Get all anggota data
  static Future<List<StudentModel>> getAllAnggota() async {
    final db = await database;
    final List<Map<String, dynamic>> listData = await db.query('anggota_baru');

    return List.generate(
      listData.length,
      (index) => StudentModel.fromMap(listData[index]),
    );
  }

  // UPDATE: Edit anggota data by ID
  static Future<void> updateAnggota(StudentModel anggota) async {
    final db = await database;
    await db.update(
      'anggota_baru',
      anggota.toMap(),
      where: 'id = ?',
      whereArgs: [anggota.id],
    );
    print("Anggota updated successfully: ${anggota.nama}");
  }

  // DELETE: Delete anggota data by ID
  static Future<void> deleteAnggota(int id) async {
    final db = await database;
    await db.delete('anggota_baru', where: 'id = ?', whereArgs: [id]);
    print("Anggota with ID $id deleted successfully.");
  }
}
