import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Edit.dart'; 
import 'Edit_user.dart';

class TaskListWidget extends StatelessWidget {
  final List<Map<dynamic, dynamic>> tasks;
  final List<String> taskIds;
  final String userRole;

  TaskListWidget(this.tasks, this.taskIds, this.userRole);

  @override
  Widget build(BuildContext context) {
    // Ordenar las tareas por fecha
    tasks.sort((task1, task2) {
      DateTime date1 = DateTime.parse(task1['date'] ?? '1970-01-01');
      DateTime date2 = DateTime.parse(task2['date'] ?? '1970-01-01');
      return date2.compareTo(date1); // Orden descendente (más reciente primero)
    });

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final taskId = taskIds[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.grey[200],
          ),
          child: ListTile(
            title: Text(task['name']), 
            onTap: () {
              if (userRole == 'usuario') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditTaskuser(taskId, task)),
                );
              } else if (userRole == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditTaskScreen(taskId, task)),
                );
              }
            },
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Detalles: ${task['detalles'] ?? 'N/A'}'),
                Text('Fecha: ${task['date'] ?? 'N/A'}'),
                Text('Usuario asignado: ${task['nombre'] ?? 'N/A'}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
