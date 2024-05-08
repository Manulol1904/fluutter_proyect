import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final Map<dynamic, dynamic> taskData;

  EditTaskScreen(this.taskId, this.taskData);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
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

  void _saveChanges() {
    // Guarda los cambios en la base de datos
    final DatabaseReference taskRef = FirebaseDatabase.instance.ref().child("tareas").child(widget.taskId);
     final DateTime now = DateTime.now();
     final String formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}'; // Formato: YYYY-MM-DD

    taskRef.update({
      'name': _nameController.text,
      'detalles': _descriptionController.text,
      'date': formattedDate,
    }).then((_) {
      // Muestra un mensaje o realiza alguna acción cuando se guarden los cambios
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cambios guardados')));
    }).catchError((error) {
      // Maneja cualquier error que ocurra al guardar los cambios
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar los cambios')));
    });
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
              onPressed: _saveChanges,
              child: Text('Guardar Cambios'),
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