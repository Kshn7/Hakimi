
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false, // Disable the debug banner
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the width and height of the device screen using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Background color
      body: Center(
        child: SingleChildScrollView( // Allows scrolling if needed on smaller screens
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08), // Dynamic padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo with White Background and Text
                CircleAvatar(
                  radius: screenWidth * 0.15, // Dynamic radius based on screen width
                  backgroundColor: Colors.white, // White background for avatar
                  child: Text(
                    'Logo App', // Text inside the avatar
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Dynamic font size
                      color: Colors.black, // Text color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05), // Dynamic spacing

                // Email TextField
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Emel',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // Dynamic spacing

                // Password TextField
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Kata Laluan',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: const Icon(Icons.visibility_off), // Hide/show password icon
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // Dynamic spacing

                // Login Button
                ElevatedButton(
                  onPressed: () {
                    // Implement login functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ), backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.3), // Button color
                  ),
                  child: Text('Log Masuk', style: TextStyle(fontSize: screenWidth * 0.045)),
                ),

                SizedBox(height: screenHeight * 0.03), // Dynamic spacing

                // Additional Links
                TextButton(
                  onPressed: () {
                    // Implement sign up functionality here
                  },
                  child: const Text('Daftar Akaun Baru', style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {
                    // Implement forgot password functionality here
                  },
                  child: const Text('Terlupa Kata Laluan?', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

