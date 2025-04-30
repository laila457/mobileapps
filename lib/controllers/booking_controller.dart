import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wellpage/models/booking_model.dart';

class BookingController {
  static const String apiUrl = 'https://10.60.5.115/api'; // Ganti dengan URL API Anda
  static Database? _database;

  // Initialize database
  static Future<Database> initDatabase() async {
    if (_database != null) return _database!;
    
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'flutter_auth');

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE booking (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            owner_name TEXT,
            phone_number TEXT,
            pet_count INTEGER,
            pet_type TEXT,
            notes TEXT,
            booking_date TEXT,
            booking_time TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
    );
    return _database!;
  }

  // Save booking to local database and sync with server
  static Future<bool> saveBooking(BookingModel booking) async {
    try {
      // Save to local database first
      Database db = await initDatabase();
      int localId = await db.insert('bookings', booking.toMap());
      
      // Try to sync with server
      await syncWithServer(booking);
      
      return true;
    } catch (e) {
      log('Error saving booking: $e');
      return false;
    }
  }

  // Sync booking with server
  static Future<bool> syncWithServer(BookingModel booking) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(booking.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Booking synced with server successfully');
        return true;
      } else {
        log('Failed to sync booking: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error syncing booking: $e');
      // We still return true because local storage succeeded
      // This will be handled by a background sync later
      return true;
    }
  }

  // Get all bookings from local database
  static Future<List<BookingModel>> getAllBookings() async {
    try {
      Database db = await initDatabase();
      final List<Map<String, dynamic>> maps = await db.query('bookings');
      
      return List.generate(maps.length, (i) {
        return BookingModel.fromMap(maps[i]);
      });
    } catch (e) {
      log('Error fetching bookings: $e');
      return [];
    }
  }

  // Get a specific booking by ID
  static Future<BookingModel?> getBookingById(int id) async {
    try {
      Database db = await initDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'bookings',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (maps.isNotEmpty) {
        return BookingModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      log('Error fetching booking: $e');
      return null;
    }
  }

  // Update a booking
  static Future<bool> updateBooking(BookingModel booking) async {
    try {
      Database db = await initDatabase();
      await db.update(
        'bookings',
        booking.toMap(),
        where: 'id = ?',
        whereArgs: [booking.id],
      );
      
      // Try to sync with server
      await http.put(
        Uri.parse('$apiUrl/${booking.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(booking.toJson()),
      );
      
      return true;
    } catch (e) {
      log('Error updating booking: $e');
      return false;
    }
  }

  // Delete a booking
  static Future<bool> deleteBooking(int id) async {
    try {
      Database db = await initDatabase();
      await db.delete(
        'bookings',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      // Try to sync with server
      await http.delete(Uri.parse('$apiUrl/$id'));
      
      return true;
    } catch (e) {
      log('Error deleting booking: $e');
      return false;
    }
  }
}