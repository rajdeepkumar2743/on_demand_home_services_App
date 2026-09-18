import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking.dart';
import '../providers/bookings_provider.dart';

class BookingDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Booking booking = ModalRoute.of(context)!.settings.arguments as Booking;
    final bookingsProvider = Provider.of<BookingsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/', // Home screen route
                  (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailRow(label: 'Service', value: booking.serviceName),
                const SizedBox(height: 16),
                DetailRow(label: 'Location', value: booking.location ?? 'N/A'),
                const SizedBox(height: 16),
                DetailRow(label: 'Date', value: booking.date),
                const SizedBox(height: 16),
                DetailRow(label: 'Time', value: booking.time ?? 'N/A'),
                const SizedBox(height: 16),
                DetailRow(label: 'Status', value: booking.status),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel Booking'),
                  onPressed: booking.status == 'Cancelled'
                      ? null
                      : () async {
                    try {
                      await bookingsProvider.cancelBooking(booking.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Booking cancelled for ${booking.serviceName}'),
                        ),
                      );
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                            (Route<dynamic> route) => false,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({required this.label, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 18),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
      ],
    );
  }
}
