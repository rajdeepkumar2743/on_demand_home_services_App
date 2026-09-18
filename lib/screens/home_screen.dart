import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../service/firestore_service.dart';
import '../service/database.dart';
import '../database/database_helper.dart';
import '../providers/user_provider.dart';
import '../providers/services_provider.dart';
import '../widgets/service_card.dart';

class NetworkCheck {
  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<List<Map<String, dynamic>>> bookingsFuture;

  @override
  void initState() {
    super.initState();
    bookingsFuture = _getUserBookings();
    _syncFirestoreServices(); // Sync on startup

    // Listen to connectivity changes to resync Firestore services
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _syncFirestoreServices(); // Re-sync when online
      }
    });
  }

  // Function to sync Firestore services to local database
  Future<void> _syncFirestoreServices() async {
    try {
      final firestoreService = FirestoreService();
      final dbHelper = DatabaseHelper.instance;

      List<Map<String, dynamic>> firestoreServices = await firestoreService.fetchServices();

      for (var service in firestoreServices) {
        await dbHelper.insertService(service);
      }

      Fluttertoast.showToast(msg: 'Services synced with Firestore');
    } catch (e) {
      print('Sync Error: $e');
      Fluttertoast.showToast(msg: 'Failed to sync services');
    }
  }

  // Handle navigation based on selected index
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(context, '/bookings', (_) => false);
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(context, '/settings', (_) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final servicesProvider = Provider.of<ServicesProvider>(context);
    final services = servicesProvider.services;

    // If user is not authenticated, redirect to login screen
    if (userProvider.userEmail.isEmpty || userProvider.userPassword.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return SizedBox.shrink();
    }

    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>( // Booking details FutureBuilder
        future: bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          List<Map<String, dynamic>> bookings = snapshot.data ?? [];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Welcome to Home Services!'),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.deepPurple, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                floating: true,
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.people),
                    onPressed: () {
                      Navigator.pushNamed(context, '/professionals');
                    },
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (ctx, i) {
                    final service = services[i];
                    return ServiceCard(service: service);
                  },
                  childCount: services.length,
                ),
              ),
              if (bookings.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (ctx, i) {
                      final booking = bookings[i];
                      return ListTile(
                        title: Text(booking['serviceName']),
                        subtitle: Text('${booking['date']} - ${booking['time']}'),
                      );
                    },
                    childCount: bookings.length,
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.blueAccent, width: 2.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }

  // Function to fetch user bookings
  Future<List<Map<String, dynamic>>> _getUserBookings() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return await DatabaseMethods().getUserBookings(currentUser.uid);
    }
    return [];
  }
}
