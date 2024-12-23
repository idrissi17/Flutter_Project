// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to LoginForm after successful sign-out
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_3_rounded, color: Colors.blue),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "User Email",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ExpansionTile(
              leading: const Icon(Icons.category),
              title: const Text("Classification"),
              children: [
                 ListTile(
                  title: const Text("ANN"),
                  onTap: () {
                    Navigator.pushNamed(context, "/ModelAnnPage");
                  },
                ),
                const ListTile(
                  title: Text("CNN"),
                
                ),
              ],
            ),
            const ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Stocks Price Prediction'),
            ),
            ListTile(
              leading: const Icon(Icons.mic),
              title: const Text('Vocal Assistance'),
              onTap: () {
                Navigator.pushNamed(context, "/assistantVoicePage");
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () => _signOut(context),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text("Welcome to Home Page!"),
      ),
    );
  }
}
