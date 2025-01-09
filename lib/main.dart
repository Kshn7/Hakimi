import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homestay_form/auth/login_page_ui.dart';
import 'package:homestay_form/calendar/calendar.dart';
import 'package:homestay_form/landing/landing.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: defaultFirebaseAppName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LandingPage(), // Changed to LoginPage
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/calendar': (context) => const BookingCalendarPage(),
      },
    );
  }
}
