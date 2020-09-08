import 'package:flutter_app/database/base_dao.dart';
import 'package:flutter_app/database/database_constants.dart';
import 'package:flutter_app/models/session_code.dart';

class SessionCodeDao implements BaseDao<SessionCode> {
  @override
  // TODO: implement createTableQuery
  String get createTableQuery => '''
          CREATE TABLE ${DatabaseConstants.sessionCodeTable} (
            ${DatabaseConstants.sessionCodeColSessionId} INTEGER NOT NULL,
            ${DatabaseConstants.sessionCodeColCode} TEXT NOT NULL,
            ${DatabaseConstants.sessionCodeColDeleted} BIT DEFAULT 0,
            PRIMARY KEY (${DatabaseConstants.sessionCodeColSessionId}, ${DatabaseConstants.sessionCodeColCode})
          )
          ''';

  @override
  List<SessionCode> fromList(List<Map<String, dynamic>> query) {
    List<SessionCode> sessions = List<SessionCode>();
    for (Map map in query) {
      sessions.add(fromMap(map));
    }
    return sessions;
  }

  @override
  SessionCode fromMap(Map<String, dynamic> query) {
    SessionCode item = SessionCode();
    item.sessionId = query[DatabaseConstants.sessionCodeColSessionId];
    item.code = query[DatabaseConstants.sessionCodeColCode];
    item.deleted = query[DatabaseConstants.sessionCodeColDeleted] == 1;
    return item;
  }

  @override
  Map<String, dynamic> toMap(SessionCode item) {
    return <String, dynamic>{
      DatabaseConstants.sessionCodeColSessionId: item.sessionId,
      DatabaseConstants.sessionCodeColCode: item.code
    };
  }
}
