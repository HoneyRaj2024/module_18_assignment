import 'package:flutter/material.dart';
import 'package:module_18_assignment/data/model/network_response.dart';
import 'package:module_18_assignment/data/model/task_model.dart';
import 'package:module_18_assignment/data/network_caller/network_caller.dart';
import 'package:module_18_assignment/data/utilities/urls.dart';
import 'package:module_18_assignment/ui/widgets/centered_progress_indicator.dart';
import 'package:module_18_assignment/ui/widgets/snack_bar_message.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.taskModel,
    required this.onUpdateTask,
  });

  final TaskModel taskModel;
  final VoidCallback onUpdateTask;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _deleteInProgress = false;
  bool _editInProgress = false;
  String dropdownValue = '';
  List<String> statusList = ['New', 'Progress', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan, Colors.blue.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: ListTile(
          title: Text(
            widget.taskModel.title ?? '',
            style: const TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.taskModel.description ?? '',
                style: const TextStyle(color: Colors.white,fontSize: 16),
              ),
              Text(
                'Date: ${widget.taskModel.createdDate}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    backgroundColor: Colors.green,
                    label: Text(
                      widget.taskModel.status ?? 'New',
                      style: const TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Colors.cyan)
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  ),
                  ButtonBar(
                    children: [
                      Visibility(
                        visible: _deleteInProgress == false,
                        replacement: const CenteredProgressIndicator(),
                        child: IconButton(
                          onPressed: () {
                            _deleteTask();
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _editInProgress == false,
                        replacement: const CenteredProgressIndicator(),
                        child: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.greenAccent,
                          ),
                          onSelected: (String selectedValue) {
                            _updateTaskStatus(selectedValue);
                          },
                          itemBuilder: (BuildContext context) {
                            return statusList.map((String value) {
                              return PopupMenuItem<String>(
                                value: value,
                                child: ListTile(
                                  title: Text(value),
                                  trailing: dropdownValue == value
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.cyan,
                                        )
                                      : null,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateTaskStatus(String status) async {
    setState(() {
      _editInProgress = true;
    });

    NetworkResponse response;
    if (status == 'Progress') {
      response = await NetworkCaller.getRequest(
        Urls.progressStatus(widget.taskModel.sId!),
      );
    } else if (status == 'Completed') {
      response = await NetworkCaller.getRequest(
        Urls.completedStatus(widget.taskModel.sId!),
      );
    } else if (status == 'Cancelled') {
      response = await NetworkCaller.getRequest(
        Urls.cancelledStatus(widget.taskModel.sId!),
      );
    } else {
      return;
    }

    if (response.isSuccess) {
      setState(() {
        dropdownValue = status;
        widget.taskModel.status = status;
        widget.onUpdateTask();
      });
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage ?? 'Update task status failed! Try again',
        );
      }
    }

    setState(() {
      _editInProgress = false;
    });
  }

  Future<void> _deleteTask() async {
    _deleteInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(
      Urls.deleteTask(widget.taskModel.sId!),
    );

    if (response.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage ?? 'Delete task failed! Try again',
        );
      }
    }
    _deleteInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
