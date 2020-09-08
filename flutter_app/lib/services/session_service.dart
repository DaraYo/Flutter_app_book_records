import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/database/session/session_dao.dart';
import 'package:flutter_app/models/scan_session.dart';
import 'package:flutter_app/services/api_base_helper.dart';
import 'package:http/http.dart' as http;

class SessionService {
  ApiBaseHelper _helper = ApiBaseHelper();

  final String syncUrl = "http://192.168.1.5:4000/sync";
  final String syncEndpoint = "";
  final String key = "";

  Future<bool> syncSessions({@required List<Session> sessions}) async {
    // AuthDto newUser = AuthDto();
    List bodyData = SessionDao().toList(sessions);
    // var response = await _helper.postWithAuthorization(syncUrl, bodyData);
    print(bodyData);
    var response = await http.post(syncUrl,
        // headers: {
        //   HttpHeaders.authorizationHeader:
        //       'Bearer ${StorageUtil.getString("token")}'
        // },
        body: json.encode(bodyData));
    return true;
  }
}
