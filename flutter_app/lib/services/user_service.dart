import 'dart:convert';

import 'package:flutter_app/dto/auth_dto.dart';
import 'package:flutter_app/dto/user_dto.dart';
import 'package:flutter_app/services/api_base_helper.dart';
import 'package:http/http.dart' as http;

class UserService {
  ApiBaseHelper _helper = ApiBaseHelper();

  final String serverUrl = "http://192.168.1.5:4000";
  final String ftnServerLogin =
      "https://fakerevizija.ftninformatika.com/api/token-auth/";
  final String loginEndpoint = "/login";

  Future<dynamic> login(AuthDto userCredentials) async {
    print(userCredentials.toMap());
    // var response = await http.post(
    //   ftnServerLogin,
    //   body: jsonEncode(userDto.toMap()),
    //   headers: {
    //     'Content-Type': 'application/json',
    //   },
    // );
    var response = await _helper.post(
        "/api/token-auth/", jsonEncode(userCredentials.toMap()));
    UserDto userDto = UserDto();
    return userDto.fromMap(response);
  }
}
