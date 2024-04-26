import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // Import for color animation

class registro extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase().reference();

  void _registerUser(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        String userID = userCredential.user!.uid;
        _database.child('usuarios').child(userID).set({
          'rol': 'usuario',
          'nombre': _nameController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cuenta creada.'),
        ));

        Navigator.pushReplacementNamed(context, '/main_tareas');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Registro',
              textStyle: TextStyle(
                fontSize: 50.0, // Adjust font size as desired
                fontWeight: FontWeight.bold,
              ),
              colors: [
                Colors.blue, // Add your desired color sequence
                Colors.green,
                Colors.red,
              ],
              textAlign: TextAlign.center,
              speed: Duration(milliseconds: 1000), // Adjust animation speed
            ),
          ],
          repeatForever: true, // Set to true for continuous animation
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _registerUser(context),
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
