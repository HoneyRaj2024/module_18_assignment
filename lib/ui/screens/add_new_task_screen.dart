import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:module_18_assignment/data/model/network_response.dart';
import 'package:module_18_assignment/data/network_caller/network_caller.dart';
import 'package:module_18_assignment/data/utilities/urls.dart';
import 'package:module_18_assignment/ui/utility/asset_paths.dart';
import 'package:module_18_assignment/ui/widgets/background_widget.dart';
import 'package:module_18_assignment/ui/widgets/centered_progress_indicator.dart';
import 'package:module_18_assignment/ui/widgets/profile_app_bar.dart';
import 'package:module_18_assignment/ui/widgets/show_dialog.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});
  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: BackgroundWidget(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),

                child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      AssetPaths.appLogoSvg,
                      width: 140,
                    ),
                    const SizedBox(height: 50),
                    TextFormField(
                      controller: _titleTEController,
                      decoration: const InputDecoration(hintText: 'Title'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionTEController,
                      maxLines: 7,
                      decoration: const InputDecoration(hintText: 'Description'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _addNewTaskInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _addNewTask();
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // New Button
                    TextButton(
                      onPressed: _backToNewTaskScreen,
                      child: const Text('Back to New Task!'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewTask() async {
    _addNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestData = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New",
    };
    NetworkResponse response = await NetworkCaller.postRequest(
      Urls.createTask,
      body: requestData,
    );
    _addNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      _clearTextFields();
      if (mounted) {
        showCustomDialog(context, 'New Task Successfully Added');
      }
    } else {
      if (mounted) {
        showCustomDialog(context, 'New task add failed! Try again!');
      }
    }
  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }

  void _backToNewTaskScreen() {
    Navigator.pop(context); // Adjust this to navigate to the New Task Screen
  }
}
