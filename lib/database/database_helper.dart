import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/booking.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('home_services.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE services (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        price REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        service_id INTEGER,
        user_id INTEGER,
        date TEXT,
        status TEXT,
        FOREIGN KEY(service_id) REFERENCES services(id)
      )
    ''');
  }

  // Insert a new service
  Future<int> insertService(Map<String, dynamic> service) async {
    final db = await instance.database;
    return await db.insert('services', service);
  }

  // Fetch all services
  Future<List<Map<String, dynamic>>> fetchServices() async {
    final db = await instance.database;
    return await db.query('services');
  }

  // Insert a new booking
  Future<int> insertBooking(Booking booking) async {
    final db = await instance.database;
    return await db.insert('bookings', booking.toMap());
  }

  // Fetch all bookings
  Future<List<Booking>> fetchBookings() async {
    final db = await instance.database;
    var result = await db.query('bookings');
    return result.isNotEmpty
        ? result.map((c) => Booking.fromMap(c)).toList()
        : [];
  }

  // Update booking status (e.g., cancel booking)
  Future<int> updateBookingStatus(int id, String status) async {
    final db = await instance.database;
    return await db.update(
      'bookings',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Sync services with the backend when the network is available
  Future<void> syncServicesWithBackend(List<Map<String, dynamic>> servicesFromBackend) async {
    final db = await instance.database;

    // Loop through each service from the backend and insert/update in the local database
    for (var service in servicesFromBackend) {
      // Check if the service already exists in the local database
      final existingService = await db.query(
        'services',
        where: 'id = ?',
        whereArgs: [service['id']],
      );

      if (existingService.isEmpty) {
        // Insert if service does not exist
        await insertService(service);
      } else {
        // Update if service already exists
        await db.update(
          'services',
          service,
          where: 'id = ?',
          whereArgs: [service['id']],
        );
      }
    }
  }
}
