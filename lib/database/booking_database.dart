import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/booking.dart';

class BookingDatabase {
  static final BookingDatabase instance = BookingDatabase._init();
  static Database? _database;

  BookingDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('bookings.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookings (
        id TEXT PRIMARY KEY,
        serviceName TEXT,
        date TEXT,
        time TEXT,
        status TEXT,
        notes TEXT,
        location TEXT,
        userId TEXT
      )
    ''');
  }

  Future<void> insertBooking(Booking booking) async {
    final db = await instance.database;

    await db.insert(
      'bookings',
      booking.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Booking>> getBookings(String userId) async {
    final db = await instance.database;

    final maps = await db.query(
      'bookings',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return maps.map((e) => Booking.fromMap(e)).toList();
  }

  Future<void> cancelBooking(String bookingId) async {
    final db = await instance.database;

    await db.update(
      'bookings',
      {'status': 'Cancelled'},
      where: 'id = ?',
      whereArgs: [bookingId],
    );
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    final db = await instance.database;

    await db.update(
      'bookings',
      {'status': status},
      where: 'id = ?',
      whereArgs: [bookingId],
    );
  }

  Future close() async {
    final db = await _database;
    db?.close();
  }
}
