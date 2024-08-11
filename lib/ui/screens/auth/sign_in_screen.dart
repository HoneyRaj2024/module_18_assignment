import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:module_18_assignment/ui/controllers/auth_controller.dart';
import 'package:module_18_assignment/ui/screens/auth/email_verification_screen.dart';
import 'package:module_18_assignment/ui/screens/auth/sign_up_screen.dart';
import 'package:module_18_assignment/ui/utility/app_colors.dart';
import 'package:module_18_assignment/ui/utility/app_constants.dart';
import 'package:module_18_assignment/ui/utility/asset_paths.dart';
import 'package:module_18_assignment/ui/widgets/background_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize AuthController
    Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetPaths.appLogoSvg,
                        width: 140,
                      ),
                      const SizedBox(height: 35),
                      Text(
                        'Get Started With',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailTEController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(hintText: 'Email'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your email address';
                          }
                          if (AppConstants.emailRegExp.hasMatch(value!) ==
                              false) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        obscureText: true,
                        controller: _passwordTEController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(hintText: 'Password'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        final authController = Get.find<AuthController>();
                        return Visibility(
                          visible: !authController.signInApiInProgress.value,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            onPressed: _onTapNextButton,
                            child:
                                const Icon(Icons.arrow_circle_right_outlined),
                          ),
                        );
                      }),
                      const SizedBox(height: 36),
                      Center(
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: _onTapForgotPasswordButton,
                              child: const Text('Forgot Password?'),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                                text: "Don't have an account? ",
                                children: [
                                  TextSpan(
                                    text: 'Sign up',
                                    style: const TextStyle(
                                        color: AppColors.themeColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _onTapSignUpButton,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      Get.find<AuthController>().signIn(
        email: _emailTEController.text.trim(),
        password: _passwordTEController.text.trim(),
      );
    }
  }

  void _onTapSignUpButton() {
    Get.to(() => const SignUpScreen());
  }

  void _onTapForgotPasswordButton() {
    Get.to(() => const EmailVerificationScreen());
  }
}
