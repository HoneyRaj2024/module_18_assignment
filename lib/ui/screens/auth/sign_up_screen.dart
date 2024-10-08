import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:module_18_assignment/data/model/network_response.dart';
import 'package:module_18_assignment/data/network_caller/network_caller.dart';
import 'package:module_18_assignment/data/utilities/urls.dart';
import 'package:module_18_assignment/ui/utility/app_colors.dart';
import 'package:module_18_assignment/ui/utility/app_constants.dart';
import 'package:module_18_assignment/ui/utility/asset_paths.dart';
import 'package:module_18_assignment/ui/widgets/background_widget.dart';
import 'package:module_18_assignment/ui/widgets/snack_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _showPassword = false.obs;
  final _registrationInProgress = false.obs;

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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetPaths.appLogoSvg,
                        width: 140,
                      ),
                      const SizedBox(height: 35),
                      Text(
                        'Join With Us',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailTEController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(hintText: 'Email'),
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
                        controller: _firstNameTEController,
                        decoration:
                        const InputDecoration(hintText: 'First name'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _lastNameTEController,
                        decoration:
                        const InputDecoration(hintText: 'Last name'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _mobileTEController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Mobile'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your mobile';
                          }
                          // if (AppConstants.mobileRegExp.hasMatch(value!) == false) {
                          //   return 'Enter a valid phone number';
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Obx(() => TextFormField(
                        obscureText: _showPassword.value == false,
                        controller: _passwordTEController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              _showPassword.value = !_showPassword.value;
                            },
                            icon: Icon(
                              _showPassword.value
                                  ? Icons.remove_red_eye
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your password';
                          }
                          return null;
                        },
                      )),
                      const SizedBox(height: 16),
                      Obx(() => Visibility(
                        visible: _registrationInProgress.value == false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _registerUser();
                            }
                          },
                          child:
                          const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      )),
                      const SizedBox(height: 36),
                      _buildBackToSignInSection(),
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

  Widget _buildBackToSignInSection() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
          text: "Have an account? ",
          children: [
            TextSpan(
              text: 'Sign In',
              style: const TextStyle(color: AppColors.themeColor),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    _registrationInProgress.value = true;

    Map<String, dynamic> requestInput = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
      "photo": ""
    };

    NetworkResponse response =
    await NetworkCaller.postRequest(Urls.registration, body: requestInput);
    _registrationInProgress.value = false;

    if (response.isSuccess) {
      _clearTextFields();
      showSnackBarMessage(Get.context!, 'Registration success');
    } else {
      showSnackBarMessage(
        Get.context!,
        response.errorMessage ?? 'Registration failed! Try again.',
      );
    }
  }

  void _clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _passwordTEController.clear();
    _mobileTEController.clear();
  }

  void _onTapSignInButton() {
    Get.back(); // Replaces Navigator.pop(context) with GetX's navigation method
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
