import 'package:flutter/material.dart';
import 'package:module_18_assignment/data/model/network_response.dart';
import 'package:module_18_assignment/data/model/task_list_wrapper_model.dart';
import 'package:module_18_assignment/data/model/task_model.dart';
import 'package:module_18_assignment/data/network_caller/network_caller.dart';
import 'package:module_18_assignment/data/utilities/urls.dart';
import 'package:module_18_assignment/ui/widgets/centered_progress_indicator.dart';
import 'package:module_18_assignment/ui/widgets/snack_bar_message.dart';
import 'package:module_18_assignment/ui/widgets/task_item.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});
  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  bool _getInProgressTasksInProgress = false;
  List<TaskModel> inProgressTasks = [];
  @override
  void initState() {
    super.initState();
    _getInProgressTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _getInProgressTasks(),
        child: Visibility(
          visible: _getInProgressTasksInProgress == false,
          replacement: const CenteredProgressIndicator(),
          child: ListView.builder(
            itemCount: inProgressTasks.length,
            itemBuilder: (context, index) {
              return TaskItem(
                taskModel: inProgressTasks[index],
                onUpdateTask: () {
                  _getInProgressTasks();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _getInProgressTasks() async {
    _getInProgressTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.progressTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      inProgressTasks = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Get progress tasks failed! Try again');
      }
    }
    _getInProgressTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
