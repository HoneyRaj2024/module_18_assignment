import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:module_18_assignment/ui/controllers/auth_controller.dart';
import 'package:module_18_assignment/ui/screens/auth/sign_in_screen.dart';
import 'package:module_18_assignment/ui/screens/main_bottom_nav_screen.dart';
import 'package:module_18_assignment/ui/utility/asset_paths.dart';
import 'package:module_18_assignment/ui/widgets/background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 1));
    bool isUserLoggedIn = await AuthController.checkAuthState();

    if (isUserLoggedIn) {
      Get.off(() => MainBottomNavScreen());
    } else {
      Get.off(() => SignInScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Center(
          child: SvgPicture.asset(
            AssetPaths.appLogoSvg,
            width: 140,
          ),
        ),
      ),
    );
  }
}
