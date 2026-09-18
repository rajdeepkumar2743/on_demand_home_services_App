import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/booking.dart';
import '../database/booking_database.dart';

class BookingsProvider with ChangeNotifier {
  List<Booking> _bookings = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String? userId;

  BookingsProvider([this.userId]);

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Sets userId and notifies listeners about the change
  void setUserId(String id) {
    userId = id;
    notifyListeners();
  }

  // Fetches all bookings for the current user from the database
  Future<void> fetchBookings() async {
    _isLoading = true;
    _errorMessage = '';  // Clear any previous error messages
    notifyListeners();

    try {
      final fetchedBookings = await BookingDatabase.instance.getBookings(userId!);
      _bookings = fetchedBookings;
    } catch (error) {
      _errorMessage = 'Error fetching bookings: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adds a new booking and updates the state
  Future<void> addBooking(Booking booking) async {
    try {
      await BookingDatabase.instance.insertBooking(booking);
      _bookings.add(booking);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error adding booking: $e';
      notifyListeners();
    }
  }

  // Cancels a booking and updates the state
  Future<void> cancelBooking(String bookingId) async {
    try {
      await BookingDatabase.instance.cancelBooking(bookingId);
      _bookings = _bookings.map((booking) {
        if (booking.id == bookingId) {
          return booking.copyWith(status: 'Cancelled');
        }
        return booking;
      }).toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error cancelling booking: $e';
      notifyListeners();
    }
  }

  Future<void> updateBookingStatus(int id, String status) async {
    await DatabaseHelper.instance.updateBookingStatus(id, status);
    await fetchBookings();  // Refresh the bookings after update
  }
  // Loads bookings for a specific user
  Future<void> loadBookings() async {
    if (userId == null) {
      _errorMessage = 'User ID is not set';
      notifyListeners();
      return;
    }
    try {
      final loadedBookings = await BookingDatabase.instance.getBookings(userId!);
      _bookings = loadedBookings;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading bookings: $e';
      notifyListeners();
    }
  }
}
