import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add user details to Firestore
  Future<void> addUser(String userId, Map<String, dynamic> userInfoMap) async {
    try {
      await _firestore.collection("User").doc(userId).set(userInfoMap);
      print("User added successfully");
    } catch (e) {
      print("Failed to add user: $e");
    }
  }

  // Add a new booking for the specific user
  Future<void> addBooking(String userId, Map<String, dynamic> bookingInfoMap) async {
    try {
      await _firestore
          .collection("Bookings")
          .doc(userId)
          .collection("UserBookings")
          .add(bookingInfoMap);
      print("Booking added successfully");
    } catch (e) {
      print("Failed to add booking: $e");
    }
  }

  // Fetch all bookings for a given user
  Future<List<Map<String, dynamic>>> getUserBookings(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("Bookings")
          .doc(userId)
          .collection("UserBookings")
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Failed to fetch bookings: $e");
      return [];
    }
  }
}
