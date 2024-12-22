// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to HomePage after successful login
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      if (e.code == 'user-not-found') {
        _showMessage(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showMessage(context, 'Wrong password provided.');
      } else {
        _showMessage(context, 'Login failed. Please try again.');
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Form"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: "Email",
                ),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: "Password",
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _signIn(context), // Pass context here
                    child: const Text("Login"),
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, "/register"),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
