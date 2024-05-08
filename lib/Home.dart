import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'tareas.dart'; 
import 'login_screen.dart';
import 'Addtask.dart'; // Suponiendo que tienes un archivo add_task_screen.dart para la pantalla de agregar tarea

class adminScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrador'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut(); // Cierra la sesión del usuario
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return _checkUserRole(user); 
          } else {
            return const Center(child: Text('No hay usuario autenticado'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
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
          if (userData['rol'] == "admin") {
            final tasksRef = FirebaseDatabase.instance.ref().child("tareas");
            
            return StreamBuilder<DatabaseEvent>(
              stream: tasksRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final tasksEventData = snapshot.data!;
                  final tasksData = tasksEventData.snapshot.value as Map<dynamic, dynamic>?;

                  if (tasksData != null && tasksData.isNotEmpty) {
                    final List<String> taskIds = tasksData.keys.toList().cast<String>(); // Obtener los IDs de las tareas
                    final List<Map<dynamic, dynamic>> tasksList = tasksData.values.toList().cast<Map<dynamic, dynamic>>();
                    return TaskListWidget(tasksList, taskIds, userData['rol']); // Pasar los IDs a TaskListWidget
                  } else {
                    // Si no hay tareas, muestra un mensaje
                    return const Center(child: Text('No hay tareas.'));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            // Si el usuario no es administrador, simplemente muestra un mensaje
            return const Center(child: Text('No tiene permiso para acceder a esta pantalla.'));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
