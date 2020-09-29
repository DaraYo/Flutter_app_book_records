import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/custom/app_exceptions.dart';
import 'package:flutter_app/dto/auth_dto.dart';
import 'package:flutter_app/pages/home/home_page.dart';
import 'package:flutter_app/services/user_service.dart';
import 'package:flutter_app/utils/secure_storage_util.dart';
import 'package:flutter_app/utils/storage_util.dart';

part 'login_page_state.dart';

class LoginPageCubit extends Cubit<LoginPageState> {
  UserService _userService;
  bool _isRememberMe;

  LoginPageCubit() : super(LoginPageInitial(false)) {
    _isRememberMe = false;
    _userService = UserService();
  }

  Future<void> rememberMeChecked(bool isChecked) async {
    _isRememberMe = isChecked;
    emit(LoginPageInitial(_isRememberMe));
  }

  Future<void> login(String email, String password, bool rememberMe,
      BuildContext context) async {
    emit(LoginIsLoading());
    AuthDto newUser = AuthDto();
    newUser.username = email;
    newUser.password = password;
    try {
      var loggedInUser = await _userService.login(newUser);
      if (loggedInUser != null) {
        StorageUtil.putString("token", loggedInUser.token);
        SecureStorageUtil.write(
            "loggedInUserFirstName", loggedInUser.firstName);
        SecureStorageUtil.write("loggedInUserLastName", loggedInUser.lastName);
        if (_isRememberMe == true) {
          SecureStorageUtil.write("loggedInUserMail", newUser.username);
          SecureStorageUtil.write("loggedInUserPass", newUser.password);
        }
        emit(LoginSuccess());
        Future.delayed(const Duration(milliseconds: 1000), () {
          redirectToHome(context);
        });
      }
    } on BadRequestException catch (ex) {
      print(ex.toString());
      var responseJson = json.decode(ex.toString());
      print(responseJson["non_field_errors"][0]);
      emit(LoginError("Loši kredencijali"));
    }
  }

  redirectToHome(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(title: 'Bibliotečki fond')));
  }
}
