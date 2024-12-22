import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class RegisterForm extends StatelessWidget {
  RegisterForm({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Form"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                ),
              ),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  icon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      print(passwordController.text);
                      try {
                        if (passwordController.text ==
                            confirmPasswordController.text) {
                          await auth.createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString(),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Registration Successful"),
                            ),
                          );
                          Navigator.pushReplacementNamed(context, "/login");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Passwords do not match!"),
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $e"),
                          ),
                        );
                      }
                    },
                    child: const Text("Register"),
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, "/login"),
                    hoverColor: const Color.fromARGB(255, 255, 255, 255),
                    child: const Text(
                      "Login",
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
