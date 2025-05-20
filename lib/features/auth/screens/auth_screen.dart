import 'package:flutter/material.dart';
import 'package:nukdi4/features/auth/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUp = true;

  final AuthService authService = AuthService();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleAuth() {
    if (isSignUp) {
      authService.signUpUser(
        context: context,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
    } else {
      authService.signInUser(
        context: context,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌸 Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🌫️ Overlay
          Container(color: Colors.white.withOpacity(0.2)),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🌿 Radio Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: true,
                          groupValue: isSignUp,
                          onChanged: (_) => setState(() => isSignUp = true),
                          activeColor: Colors.blue,
                        ),
                        const Text(
                          "Create Account",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 20),
                        Radio(
                          value: false,
                          groupValue: isSignUp,
                          onChanged: (_) => setState(() => isSignUp = false),
                          activeColor: Colors.teal,
                        ),
                        const Text(
                          "Sign In.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    if (isSignUp) ...[
                      _buildInput(_firstNameController, "First Name"),
                      const SizedBox(height: 10),
                      _buildInput(_lastNameController, "Last Name"),
                      const SizedBox(height: 10),
                      _buildInput(_phoneController, "Phone Number"),
                      const SizedBox(height: 10),
                    ],

                    _buildInput(_emailController, "Email"),
                    const SizedBox(height: 10),
                    _buildInput(_passwordController, "Password", obscure: true),

                    const SizedBox(height: 25),

                    ElevatedButton(
                      onPressed: _handleAuth,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        isSignUp ? "Sign Up" : "Sign In",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
