import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:module_18_assignment/ui/controllers/auth_controller.dart';
import 'package:module_18_assignment/ui/screens/auth/sign_in_screen.dart';
import 'package:module_18_assignment/ui/screens/update_profile_screen.dart';
import 'package:module_18_assignment/ui/utility/app_colors.dart';

AppBar profileAppBar(BuildContext context, [bool fromUpdateProfile = false]) {
  return AppBar(
    backgroundColor: AppColors.themeColor,
    elevation: 0,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    leading: GestureDetector(
      onTap: () {
        if (!fromUpdateProfile) {
          Get.to(() => UpdateProfileScreen());
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.memory(
              base64Decode(AuthController.userData?.photo ?? ''),
            ),
          ),
        ),
      ),
    ),
    title: GestureDetector(
      onTap: () {
        if (!fromUpdateProfile) {
          Get.to(() => const UpdateProfileScreen());
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AuthController.userData?.fullName ?? '',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            AuthController.userData?.email ?? '',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        onPressed: () async {
          await AuthController.clearAllData();
          Get.offAll(() => SignInScreen());
        },
        icon: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
    ],
  );
}
