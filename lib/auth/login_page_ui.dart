import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResponsiveLoginPage extends StatefulWidget {
  const ResponsiveLoginPage({super.key});

  @override
  State<ResponsiveLoginPage> createState() => _ResponsiveLoginPageState();
}

class _ResponsiveLoginPageState extends State<ResponsiveLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _register = false;
  bool _forgot = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  String? validateEmail(String? value) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (value == null || value.isEmpty) return 'Sila masukkan emel';
    if (!emailRegex.hasMatch(value)) return 'Emel tidak sah';
    return null;
  }

  String? validatePassword(String? value) {
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (value == null || value.isEmpty) return 'Sila masukkan kata laluan';
    if (!passwordRegex.hasMatch(value)) {
      return 'Kata laluan mesti sekurang-kurangnya 8 aksara dan mengandungi nombor';
    }
    return null;
  }

  Future<void> _handleAuthAction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_forgot) {
        await _auth.sendPasswordResetEmail(email: _emailController.text);
        _showSnackBar('E-mel tetapan semula telah dihantar!');
      } else if (_register) {
        await _auth.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        _showSnackBar('Akaun berjaya didaftarkan!');
      } else {
        await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        _showSnackBar('Log masuk berjaya!');
      }
    } catch (e) {
      _showSnackBar('Ralat: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        bool isMobile = screenWidth < 600;
        bool isTablet = screenWidth >= 600 && screenWidth < 1024;
        bool isWeb = screenWidth >= 1024;

        double formWidth = isMobile
            ? double.infinity
            : isTablet
                ? screenWidth * 0.8
                : 500;

        return Scaffold(
          backgroundColor: Colors.lightBlue[50],
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 32,
                vertical: 32,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: formWidth),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.blue.shade100,
                            child: Icon(Icons.person,
                                size: 50, color: Colors.blue),
                          ),
                          const SizedBox(height: 24),

                          // Email Field
                          _buildTextField(
                            label: 'Emel',
                            icon: Icons.email_outlined,
                            controller: _emailController,
                            validator: validateEmail,
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          if (!_forgot)
                            _buildTextField(
                              label: 'Kata Laluan',
                              icon: Icons.lock_outline,
                              controller: _passwordController,
                              validator: validatePassword,
                              obscure: !_isPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () => setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                }),
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _handleAuthAction,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white),
                                    )
                                  : Icon(_forgot
                                      ? Icons.refresh
                                      : _register
                                          ? Icons.person_add
                                          : Icons.login),
                              label: Text(
                                _forgot
                                    ? 'Tetapkan Semula'
                                    : _register
                                        ? 'Daftar'
                                        : 'Log Masuk',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Toggle Options
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_register
                                  ? 'Sudah ada akaun? '
                                  : 'Belum ada akaun? '),
                              GestureDetector(
                                onTap: () => setState(() {
                                  _register = !_register;
                                  _forgot = false;
                                }),
                                child: Text(
                                  _register ? 'Log Masuk' : 'Daftar',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),

                          if (!_forgot)
                            TextButton(
                              onPressed: () => setState(() {
                                _forgot = true;
                                _register = false;
                              }),
                              child: const Text(
                                'Terlupa Kata Laluan?',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
