import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _register = false;
  bool _forgot = false;
  bool _isPasswordVisible = false; // Track password visibility
  @override
  Widget build(BuildContext context) {
    // Get the width and height of the device screen using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Background color
      body: Center(
        child: SingleChildScrollView(
          // Allows scrolling if needed on smaller screens
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            // Dynamic padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo with White Background and Text
                CircleAvatar(
                  radius: screenWidth * 0.15,
                  // Dynamic radius based on screen width
                  backgroundColor: Colors.white,
                  // White background for avatar
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
                TextFormField(
                  controller: _emailController,
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
                if (!_forgot)
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Kata Laluan',
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                      // Hide/show password icon
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
                    if (_forgot) {
                      resetPassword(_emailController.text);
                    } else {
                      _register
                          ? addUser(
                              _emailController.text, _passwordController.text)
                          : loginUser(_emailController.value.text,
                              _passwordController.value.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.2), // Button color
                  ),
                  child: Text(
                    _forgot
                        ? 'Tetapkan semula'
                        : _register
                            ? 'Daftar'
                            : 'Log Masuk',
                    style: TextStyle(fontSize: screenWidth * 0.045),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: screenHeight * 0.03), // Dynamic spacing

                // Additional Links
                TextButton(
                  onPressed: () {
                    setState(() {});
                    _register = !_register;
                    _forgot = false;
                  },
                  child: Text(_register ? 'Log masuk' : 'Daftar Akaun Baru',
                      style: const TextStyle(color: Colors.blue)),
                ),
                if (!_forgot)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _forgot = true;
                      });
                    },
                    child: const Text('Terlupa Kata Laluan?',
                        style: TextStyle(color: Colors.blue)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
      // Navigate to home page or another screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: ${e.toString()}')),
      );
    }
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password Reset Email Sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> addUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User Added Successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Adding User: ${e.toString()}')),
      );
    }
  }
}
