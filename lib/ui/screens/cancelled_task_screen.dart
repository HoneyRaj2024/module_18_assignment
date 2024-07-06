import 'package:flutter/material.dart';
import 'package:module_18_assignment/data/model/task_model.dart';
import 'package:module_18_assignment/ui/widgets/task_item.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  List<TaskModel> tasks = [];

  @override
  Widget build(BuildContext context) {
    List<TaskModel> cancelledTasks = tasks.where((task) => task.status == 'Cancelled').toList();

    return Scaffold(
      body: ListView.builder(
        itemCount: cancelledTasks.length,
        itemBuilder: (context, index) {
          return TaskItem(
            taskModel: cancelledTasks[index],
            onUpdateTask: () {
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
