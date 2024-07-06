import 'package:flutter/material.dart';
import 'package:module_18_assignment/data/model/task_model.dart';
import 'package:module_18_assignment/ui/widgets/task_item.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  List<TaskModel> tasks = [];

  @override
  Widget build(BuildContext context) {
    List<TaskModel> inProgressTasks = tasks.where((task) => task.status == 'Progress').toList();

    return Scaffold(
      body: ListView.builder(
        itemCount: inProgressTasks.length,
        itemBuilder: (context, index) {
          return TaskItem(
            taskModel: inProgressTasks[index],
            onUpdateTask: () {
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
