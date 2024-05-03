import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TaskListWidget extends StatelessWidget {
  final List<Map<dynamic, dynamic>> tasks;

  TaskListWidget(this.tasks);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.grey[200], // Color del rectángulo
          ),
          child: ListTile(
            title: Text(task['name']), // Nombre de la tarea
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Detalles: ${task['detalles'] ?? 'N/A'}'), // Detalles de la tarea
                Text('Fecha: ${task['date'] ?? 'N/A'}'), // Fecha de la tarea
                Text('Usuario asignado: ${task['nombre'] ?? 'N/A'}'), // Nombre del usuario asignado
              ],
            ),
          ),
        );
      },
    );
  }
}
