import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(), // Changed to LoginPage
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Create controllers for the TextFields
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.15,
                  backgroundColor: Colors.white,
                  child: Text(
                    'Logo App',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // Email TextField
                TextField(
                  controller: emailController, // Use the controller here
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
                SizedBox(height: screenHeight * 0.02),

                // Password TextField
                TextField(
                  controller: passwordController, // Use the controller here
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Kata Laluan',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: const Icon(Icons.visibility_off),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Login Button
                ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim(); // Get email from controller
                    String password = passwordController.text.trim(); // Get password from controller

                    try {
                      // Sign in the user
                      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // Navigate to the next page or show success message here
                      print("Login successful!"); // You can change this to a navigation action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login Successful!')),
                      );
                      // Navigate to a different page after successful login
                    } on FirebaseAuthException catch (e) {
                      // Handle error (show a message to the user)
                      print('Error: $e'); // You can also show a dialog or a Snackbar to inform the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login Failed: ${e.message}')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.3,
                    ),
                  ),
                  child: Text('Log Masuk', style: TextStyle(fontSize: screenWidth * 0.045)),
                ),

                SizedBox(height: screenHeight * 0.03),

                // Additional Links
                TextButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    await addUser(email, passwordController.text.trim(), context);
                  },
                  child: const Text('Daftar Akaun Baru', style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    await resetPassword(email, context);
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

  Future<void> addUser(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User Added Successfully!')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Adding User: ${e.message}')),
      );
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password Reset Email Sent!')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }
}










