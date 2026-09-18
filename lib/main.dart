import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:on_demand_home_services/service/auth.dart';
import 'package:provider/provider.dart';

import '/service/auth.dart';
import 'service/firestore_service.dart';
import 'database/database_helper.dart';

import 'providers/user_provider.dart';
import 'providers/account_settings_provider.dart';
import 'providers/bookings_provider.dart';
import 'providers/privacy_settings_provider.dart';
import 'providers/notification_settings_provider.dart';
import 'providers/services_provider.dart';
import 'providers/professionals_provider.dart';

import 'models/service.dart';

import 'screens/home_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/my_bookings_screen.dart';
import 'screens/subscription_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/account_settings_screen.dart';
import 'screens/update_personal_info_screen.dart';
import 'screens/update_phone_number_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/email_preferences_screen.dart';
import 'screens/security_settings_screen.dart';
import 'screens/notification_settings_screen.dart';
import 'screens/privacy_settings_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/about_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/booking_details_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/contact_us_screen.dart';
import 'screens/report_problem_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/terms_of_service_screen.dart';
import 'screens/professional_list_screen.dart';
import 'screens/login_screen.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AccountSettingsProvider()),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
        ChangeNotifierProvider(create: (_) => ProfessionalsProvider()),
        ChangeNotifierProvider(create: (_) => BookingsProvider()..loadBookings()),
        ChangeNotifierProvider(create: (_) => NotificationSettingsProvider()),
        ChangeNotifierProvider(create: (_) => PrivacySettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );

  // Sync services from Firestore
  Future.delayed(Duration.zero, () => syncServicesWithFirestore());
}

Future<void> syncServicesWithFirestore() async {
  try {
    final firestoreService = FirestoreService();
    final dbHelper = DatabaseHelper.instance;

    List<Map<String, dynamic>> services = await firestoreService.fetchServices();

    for (var service in services) {
      await dbHelper.insertService(service);
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error syncing services from Firestore: $e');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'On-Demand Home Services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthChecker(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/homee': (context) => const Home(),
        '/login': (context) => const LoginScreen(),
        '/bookings': (context) => BookingsScreen(),
        '/myBookings': (context) => MyBookingsScreen(),
        '/bookingDetails': (context) => BookingDetailsScreen(),
        '/subscriptions': (context) => SubscriptionScreen(),
        '/settings': (context) => SettingsScreen(),
        '/professionals': (context) => ProfessionalListScreen(),
        '/accountSettings': (context) => AccountSettingsScreen(),
        '/updatePersonalInfo': (context) => UpdatePersonalInfoScreen(),
        '/updatePhoneNumber': (context) => UpdatePhoneNumberScreen(),
        '/changePassword': (context) => ChangePasswordScreen(),
        '/emailPreferences': (context) => EmailPreferencesScreen(),
        '/securitySettings': (context) => SecuritySettingsScreen(),
        '/notificationSettings': (context) => NotificationSettingsScreen(),
        '/privacySettings': (context) => PrivacySettingsScreen(),
        '/helpSupport': (context) => HelpSupportScreen(),
        '/about': (context) => AboutScreen(),
        '/feedback': (context) => FeedbackScreen(),
        '/faq': (context) => FAQScreen(),
        '/contactUs': (context) => ContactUsScreen(),
        '/reportProblem': (context) => ReportProblemScreen(),
        '/privacyPolicy': (context) => PrivacyPolicyScreen(),
        '/termsOfService': (context) => TermsOfServiceScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/booking') {
          final service = settings.arguments as Service?;
          if (service != null) {
            return MaterialPageRoute(
              builder: (context) => BookingScreen(service: service),
            );
          }
        }
        return null;
      },
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return FutureBuilder<bool>(
      future: auth.isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData && snapshot.data == true) {
          return HomeScreen(); // User is logged in
        } else {
          return const LoginScreen(); // User is not logged in
        }
      },
    );
  }
}
