import 'package:flutter/material.dart';
import 'package:module_18_assignment/data/model/network_response.dart';
import 'package:module_18_assignment/data/model/task_by_status_count_wrapper_model.dart';
import 'package:module_18_assignment/data/model/task_count_by_status_model.dart';
import 'package:module_18_assignment/data/model/task_list_wrapper_model.dart';
import 'package:module_18_assignment/data/model/task_model.dart';
import 'package:module_18_assignment/data/network_caller/network_caller.dart';
import 'package:module_18_assignment/data/utilities/urls.dart';
import 'package:module_18_assignment/ui/screens/add_new_task_screen.dart';
import 'package:module_18_assignment/ui/utility/app_colors.dart';
import 'package:module_18_assignment/ui/widgets/centered_progress_indicator.dart';
import 'package:module_18_assignment/ui/widgets/snack_bar_message.dart';
import 'package:module_18_assignment/ui/widgets/task_item.dart';
import 'package:module_18_assignment/ui/widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});
  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTasksInProgress = false;
  bool _getTaskCountByStatusInProgress = false;
  List<TaskModel> newTaskList = [];
  List<TaskCountByStatusModel> taskCountByStatusList = [];

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
    _getNewTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Column(
          children: [
            _buildSummarySection(),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _getNewTasks();
                  _getTaskCountByStatus();
                },
                child: Visibility(
                  visible: _getNewTasksInProgress == false,
                  replacement: const CenteredProgressIndicator(),
                  child: ListView.builder(
                    itemCount: newTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        taskModel: newTaskList[index],
                        onUpdateTask: () {
                          _getNewTasks();
                          _getTaskCountByStatus();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: FloatingActionButton(
          onPressed: _onTapAddButton,
          backgroundColor: AppColors.cyanThemeColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _onTapAddButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Visibility(
      visible: _getTaskCountByStatusInProgress == false,
      replacement: const SizedBox(
        height: 100,
        child: CenteredProgressIndicator(),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: taskCountByStatusList.map((e) {
            return Container(
              decoration: BoxDecoration(
                gradient: getStatusGradient(e.sId ?? 'Unknown'),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: TaskSummaryCard(
                title: (e.sId ?? 'Unknown').toUpperCase(),
                count: e.sum.toString(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  LinearGradient getStatusGradient(String status) {
    switch (status) {
      case 'New':
        return LinearGradient(
          colors: [Colors.green.shade200, Colors.green.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Progress':
        return LinearGradient(
          colors: [Colors.blue.shade200, Colors.blue.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Completed':
        return LinearGradient(
          colors: [Colors.cyan.shade200, Colors.cyan.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Cancelled':
        return LinearGradient(
          colors: [Colors.red.shade200, Colors.red.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [Colors.cyan, Colors.blue.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Future<void> _getNewTasks() async {
    _getNewTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      newTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? 'Get new task failed! Try again');
      }
    }
    _getNewTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
          TaskCountByStatusWrapperModel.fromJson(response.responseData);
      taskCountByStatusList =
          taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage ?? 'Get task count by status failed! Try again',
        );
      }
    }
    _getTaskCountByStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
