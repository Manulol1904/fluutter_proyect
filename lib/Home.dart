
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class adminScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Administrador')),
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return _checkUserRole(user); // No necesitas pasar el contexto aquí
          } else {
            return Center(child: Text('No hay usuario autenticado'));
          }
        },
      ),
    );
  }

  Widget _checkUserRole(User user) {
    final userId = user.uid;
    final userRef = FirebaseDatabase.instance.ref().child("usuarios").child(userId);

    return StreamBuilder<DatabaseEvent>(
      stream: userRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final eventData = snapshot.data!;
          final userData = eventData.snapshot.value as Map<dynamic, dynamic>;
          if (userData != null && userData['rol'] == "admin") {
            return Center(child: Text('¡Inicio de sesión exitoso como administrador!'));
          } else {
            // Si el usuario no es administrador, simplemente muestra un mensaje
            return Center(child: Text('No tiene permiso para acceder a esta pantalla.'));
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}


