import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditTaskuser extends StatefulWidget {
  final String taskId;
  final Map<dynamic, dynamic> taskData;

  EditTaskuser(this.taskId, this.taskData);

  @override
  _EditTaskuserState createState() => _EditTaskuserState();
}

class _EditTaskuserState extends State<EditTaskuser> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.taskData['name']);
    _descriptionController = TextEditingController(text: widget.taskData['detalles']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  void _deleteTask() {
    // Elimina la tarea de la base de datos
    final DatabaseReference taskRef = FirebaseDatabase.instance.ref().child("tareas").child(widget.taskId);
    taskRef.remove().then((_) {
      // Muestra un mensaje o realiza alguna acción cuando se elimine la tarea
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tarea eliminada')));
      Navigator.pop(context); // Regresa a la pantalla anterior después de eliminar la tarea
    }).catchError((error) {
      // Maneja cualquier error que ocurra al eliminar la tarea
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar la tarea')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tarea'),
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
              maxLines: null, // Permite que el campo de texto tenga varias líneas
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _deleteTask, // Llama a la función para eliminar la tarea
              child: Text('Eliminar Tarea'),
            ),
          ],
        ),
      ),
    );
  }
}