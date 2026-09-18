import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bookings_provider.dart';
import '../models/booking.dart';

class MyBookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch bookings provider and check loading state
    final bookingsProvider = Provider.of<BookingsProvider>(context);
    final bookings = bookingsProvider.bookings;
    final isLoading = bookingsProvider.isLoading;
    final errorMessage = bookingsProvider.errorMessage;

    // Fetch bookings if not already done (only after the widget is built)
    if (!isLoading && bookings.isEmpty && errorMessage.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        bookingsProvider.fetchBookings();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/', // Clear all routes and go to home
                  (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              bookingsProvider.fetchBookings(); // Trigger refresh
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : errorMessage.isNotEmpty
          ? Center(child: Text('Error: $errorMessage', style: TextStyle(color: Colors.red)))
          : bookings.isEmpty
          ? const Center(child: Text('No bookings available.'))
          : ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return ListTile(
            title: Text(booking.serviceName),
            subtitle: Text('Date: ${booking.date}\nStatus: ${booking.status}'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/bookingDetails',
                arguments: booking,
              );
            },
          );
        },
      ),
    );
  }
}
