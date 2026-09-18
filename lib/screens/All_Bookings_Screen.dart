import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bookings_provider.dart';
import '../models/booking.dart';

class AllBookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Call fetchBookings() when the screen is initialized
    Provider.of<BookingsProvider>(context, listen: false).fetchBookings();

    return Scaffold(
      appBar: AppBar(
        title: Text('All Bookings'),
      ),
      body: Consumer<BookingsProvider>(
        builder: (context, bookingsProvider, child) {
          // Show loading indicator if data is still being fetched
          if (bookingsProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          // Show error message if fetching failed
          if (bookingsProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Text('Error: ${bookingsProvider.errorMessage}'),
            );
          }

          final bookings = bookingsProvider.bookings;

          return ListView.builder(
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
          );
        },
      ),
    );
  }
}
