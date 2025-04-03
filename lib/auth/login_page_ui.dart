import 'package:auto_size_text/auto_size_text.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _register = false;
  bool _forgot = false;
  bool _isPasswordVisible = false;
  // Email validation function using Regex
  String? validateEmail(String? value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null; // No error
  }

  // Password validation function using Regex
  String? validatePassword(String? value) {
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (!passwordRegex.hasMatch(value)) {
      return 'Password must be at least 8 characters long with letters and numbers';
    }
    return null; // No error
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth > 600 && screenWidth <= 1024; //for tablet view
    bool isWeb = screenWidth > 1024; //for web view

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isWeb ? screenWidth * 0.1 : 20),
            child: Form(
              key: _formKey,
              child: Container(
                width: isWeb || isTablet
                    ? screenWidth * 0.6
                    : double.infinity, //tab
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: isWeb ? 100 : 70,
                      backgroundColor: Colors.white,
                      child: Center(
                        child: AutoSizeText(
                          'Logo App',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isWeb ? 32 : 24, //for web
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    // Email Field
                    SizedBox(
                      width: isWeb
                          ? screenWidth * 0.3
                          : isTablet
                              ? screenWidth * 0.7
                              : double
                                  .infinity, //for mobile,tablet and web view
                      child: TextFormField(
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
                        validator:
                            validateEmail, // Updated with email validation
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Password Field
                    if (!_forgot)
                      SizedBox(
                        width: isWeb
                            ? screenWidth * 0.3
                            : isTablet
                                ? screenWidth * 0.7
                                : double.infinity, //added here too
                        child: TextFormField(
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
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator:
                              validatePassword, // Updated with password validation
                        ),
                      ),
                    SizedBox(height: screenHeight * 0.05),

                    // Login Button
                    SizedBox(
                      width: isWeb
                          ? screenWidth * 0.3
                          : isTablet
                              ? screenWidth * 0.6
                              : double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Validation passed
                            if (_forgot) {
                              resetPassword(_emailController.text);
                            } else {
                              _register
                                  ? addUser(
                                      _emailController.text,
                                      _passwordController.text,
                                    )
                                  : loginUser(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.blue,
                          minimumSize: Size(screenWidth * 0.2, 50),
                        ),
                        child: AutoSizeText(
                          _forgot
                              ? 'Tetapkan semula'
                              : _register
                                  ? 'Daftar'
                                  : 'Log Masuk',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Register & Forgot Password Links
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _register = !_register;
                          _forgot = false;
                        });
                      },
                      child: Text(
                        _register ? 'Log masuk' : 'Daftar Akaun Baru',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                    if (!_forgot)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _forgot = true;
                          });
                        },
                        child: Text(
                          'Terlupa Kata Laluan?',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
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
    } else {
      try {
        await _auth.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reset password send to email!')),
        );
      } on FirebaseAuthException catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.message.toString())),
        );
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );
      }
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
