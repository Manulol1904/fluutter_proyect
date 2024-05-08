import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _selectedUserName = '';
  List<String> _userNames = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _fetchUserNames(); // Obtener los nombres de usuario al iniciar la pantalla
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _fetchUserNames() {
    final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("usuarios");
    usersRef.onValue.listen((DatabaseEvent event) {
      final Map<dynamic, dynamic>? usersData = event.snapshot.value as Map<dynamic, dynamic>?;

      if (usersData != null) {
        setState(() {
          _userNames = usersData.values.where((userData) => userData['rol'] == 'usuario').map<String>((userData) => userData['nombre'] as String).toList();
          _selectedUserName = _userNames.isNotEmpty ? _userNames.first : '';
        });
      }
    }, onError: (error) {
      print("Error fetching user names: $error");
    });
  }

  void _addTask() {
    final DatabaseReference tasksRef = FirebaseDatabase.instance.ref().child("tareas");
    final String name = _nameController.text;
    final String description = _descriptionController.text;
    final String assignedUser = _selectedUserName;
    final DateTime now = DateTime.now();
    final String formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
     
     
    tasksRef.push().set({
      'name': name,
      'detalles': description,
      'date': formattedDate,
      'nombre': assignedUser, // Agregar el usuario asignado a la tarea
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tarea agregada')));
      _nameController.clear();
      _descriptionController.clear();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al agregar la tarea')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Tarea'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre de la tarea'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
              maxLines: null, // Permitir que el campo de texto tenga varias líneas
            ),
            SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _selectedUserName,
              onChanged: (String? value) {
                setState(() {
                  _selectedUserName = value!;
                });
              },
              items: _userNames.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Seleccionar usuario'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Agregar Tarea'),
            ),
          ],
        ),
      ),
    );
  }
}
