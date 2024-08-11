import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:module_18_assignment/ui/screens/cancelled_task_screen.dart';
import 'package:module_18_assignment/ui/screens/completed_task_screen.dart';
import 'package:module_18_assignment/ui/screens/in_progress_task_screen.dart';
import 'package:module_18_assignment/ui/screens/new_task_screen.dart';
import 'package:module_18_assignment/ui/utility/app_colors.dart';
import 'package:module_18_assignment/ui/widgets/profile_app_bar.dart';
import 'package:module_18_assignment/ui/controllers/main_bottom_nav_controller.dart'; // Import the controller

class MainBottomNavScreen extends StatelessWidget {
  MainBottomNavScreen({super.key});

  final MainBottomNavController _navController = Get.put(MainBottomNavController());

  final List<Widget> _screens = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    InProgressTaskScreen(),
    CancelledTaskScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: Obx(() {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _screens[_navController.selectedIndex.value],
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: _navController.selectedIndex.value,
          onTap: (index) => _navController.changeIndex(index),
          selectedItemColor: AppColors.themeColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'New Task'),
            BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Completed'),
            BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit), label: 'In Progress'),
            BottomNavigationBarItem(icon: Icon(Icons.close), label: 'Cancelled'),
          ],
        );
      }),
    );
  }
}
