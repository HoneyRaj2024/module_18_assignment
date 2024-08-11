import 'dart:convert';
import 'package:get/get.dart';
import 'package:module_18_assignment/data/model/user_model.dart';
import 'package:module_18_assignment/data/model/login_model.dart';
import 'package:module_18_assignment/data/model/network_response.dart';
import 'package:module_18_assignment/data/network_caller/network_caller.dart';
import 'package:module_18_assignment/data/utilities/urls.dart';
import 'package:module_18_assignment/ui/screens/main_bottom_nav_screen.dart';
import 'package:module_18_assignment/ui/widgets/snack_bar_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static const String _accessTokenKey = 'access-token';
  static const String _userDataKey = 'user-data';
  static String accessToken = '';
  static UserModel? userData;

  var signInApiInProgress = false.obs;

  static Future<void> saveUserAccessToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    accessToken = token;
  }

  static Future<String?> getUserAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_accessTokenKey);
  }

  static Future<void> saveUserData(UserModel user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
      _userDataKey,
      jsonEncode(user.toJson()),
    );
    userData = user;
  }

  static Future<UserModel?> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? data = sharedPreferences.getString(_userDataKey);
    if (data == null) return null;

    UserModel userModel = UserModel.fromJson(jsonDecode(data));
    return userModel;
  }

  static Future<void> clearAllData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  static Future<bool> checkAuthState() async {
    String? token = await getUserAccessToken();

    if (token == null) return false;

    accessToken = token;
    userData = await getUserData();

    return true;
  }

  Future<void> signIn({required String email, required String password}) async {
    signInApiInProgress.value = true;

    Map<String, dynamic> requestData = {
      'email': email,
      'password': password,
    };

    final NetworkResponse response =
    await NetworkCaller.postRequest(Urls.login, body: requestData);
    signInApiInProgress.value = false;

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await saveUserAccessToken(loginModel.token!);
      await saveUserData(loginModel.userModel!);

      Get.offAll(() => MainBottomNavScreen());
    } else {
      showSnackBarMessage(
        Get.context!,
        response.errorMessage ?? 'Email/password is not correct. Try again',
      );
    }
  }
}
