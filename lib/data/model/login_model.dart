import 'package:module_18_assignment/data/model/user_model.dart';

class LoginModel {
  String? status;
  String? token;
  UserModel? userModel;

  // Constructor
  LoginModel({this.status, this.token, this.userModel});

  // Factory constructor to create an instance from JSON
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json['status'],
      token: json['token'],
      userModel: json['data'] != null ? UserModel.fromJson(json['data']) : null,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    if (userModel != null) {
      data['data'] = userModel!.toJson();
    }
    return data;
  }
}
