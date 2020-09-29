import 'dart:io';
import 'package:flutter_app/custom/app_exceptions.dart';
import 'package:flutter_app/dto/auth_dto.dart';
import 'package:flutter_app/dto/user_dto.dart';
import 'package:flutter_app/utils/secure_storage_util.dart';
import 'package:flutter_app/utils/storage_util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ApiBaseHelper {
  final String _baseUrl = "https://fakerevizija.ftninformatika.com";

  Future<dynamic> get(String url) async {
    print('Api Get, url $url');
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api get recieved!');
    return responseJson;
  }

  Future<dynamic> getWithAuthorization(String url) async {
    print('Api Get, url $url');
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'JWT ${StorageUtil.getString("token")}'
      });
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api get recieved!');
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body) async {
    print('Api Post, url $url');
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url, body: body, headers: {
        'Content-Type': 'application/json',
      });
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> postWithAuthorization(String url, dynamic body) async {
    print('Api Post, url $url');
    var responseJson;
    try {
      final response = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'JWT ${StorageUtil.getString("token")}'
      });
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> put(String url, dynamic body) async {
    print('Api Put, url $url');
    var responseJson;
    try {
      final response = await http.put(_baseUrl + url, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api put.');
    print(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    print('Api delete, url $url');
    var apiResponse;
    try {
      final response = await http.delete(_baseUrl + url);
      apiResponse = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api delete.');
    return apiResponse;
  }

  dynamic _returnResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        AuthDto newUser = AuthDto();
        newUser.username = await SecureStorageUtil.read("loggedInUserMail");
        newUser.password = await SecureStorageUtil.read("loggedInUserPass");
        if (newUser.username != null && newUser.password != null) {
          try {
            var response =
                await post("/api/token-auth/", jsonEncode(newUser.toMap()));
            UserDto userDto = UserDto();
            var loggedInUser = userDto.fromMap(response);
            StorageUtil.putString("token", loggedInUser.token);
          } on SocketException {
            throw FetchDataException('No Internet connection');
          }
        } else {
          throw UnauthorisedException(response.body.toString());
        }
        break;
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
