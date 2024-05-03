
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart'; // Importa FirebaseDatabase
import 'Home.dart'; 
import 'usuarios.dart'; 
import 'register.dart'; 
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Handle successful login
      print('Inicio de sesión exitoso: ${userCredential.user!.uid}');

      // Retrieve user data from Firebase Realtime Database
      final userId = userCredential.user!.uid;
      final userRef = FirebaseDatabase.instance.ref().child("usuarios").child(userId);

      DatabaseEvent event = await userRef.once(); // Get the database event
      final DataSnapshot snapshot = event.snapshot; // Extract the DataSnapshot

      if (snapshot.value != null) { // Check if there's any data
        final userData = snapshot.value as Map<dynamic, dynamic>;
        if (userData['rol'] == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => adminScreen()), // Replace with your admin screen
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => userScreen()), // Replace with regular user screen
          );
        }
      } else {
        print('Error: No data found in database');
        // Handle the case where no user data is found
      }
    } catch (e) {
      // Handle authentication errors
      print('Error de inicio de sesión: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de inicio de sesión: $e')),
      );
    }
  }

  void _goToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => registro()), // Replace with your registration screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Login',
              textStyle: const TextStyle(
                fontSize: 50.0, // Adjust font size as desired
                fontWeight: FontWeight.bold,
              ),
              colors: [
                Colors.blue, // Add your desired color sequence
                Colors.green,
                Colors.red,
              ],
              textAlign: TextAlign.center,
              speed: const Duration(milliseconds: 1000), // Adjust animation speed
            ),
          ],
          repeatForever: true, // Set to true for continuous animation
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _signInWithEmailAndPassword(context),
              child: const Text('Iniciar sesión'),
            ),
            const SizedBox(height: 8.0),
            TextButton(
              onPressed: () => _goToRegister(context),
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
