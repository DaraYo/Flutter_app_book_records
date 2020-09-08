import 'package:flutter_app/database/base_dao.dart';
import 'package:flutter_app/database/database_constants.dart';
import 'package:flutter_app/models/scan_session.dart';

class SessionDao implements BaseDao<Session> {
  @override
  // TODO: implement createTableQuery
  String get createTableQuery => '''
          CREATE TABLE ${DatabaseConstants.sessionTable} (
            ${DatabaseConstants.sessionColumnId} INTEGER PRIMARY KEY,
            ${DatabaseConstants.sessionColumnName} TEXT NOT NULL,
            ${DatabaseConstants.sessionColumnTimestamp} INTEGER NOT NULL,
            ${DatabaseConstants.sessionColumnSessionDeleted} INTEGER NOT NULL,
            ${DatabaseConstants.sessionColumnSessionSent} INTEGER NOT NULL,
            ${DatabaseConstants.sessionColumnFKUserId} INTEGER
          )
          ''';

  @override
  List<Session> fromList(List<Map<String, dynamic>> query) {
    List<Session> sessions = List<Session>();
    for (Map map in query) {
      sessions.add(fromMap(map));
    }
    return sessions;
  }

  @override
  Session fromMap(Map<String, dynamic> query) {
    Session note = Session();
    note.id = query[DatabaseConstants.sessionColumnId];
    note.name = query[DatabaseConstants.sessionColumnName];
    note.timestamp = query[DatabaseConstants.sessionColumnTimestamp];
    note.deleted = query[DatabaseConstants.sessionColumnSessionDeleted] == 1;
    note.sent = query[DatabaseConstants.sessionColumnSessionSent] == 1;
    note.userId = query[DatabaseConstants.sessionColumnFKUserId];
    return note;
  }

  @override
  Map<String, dynamic> toMap(Session item) {
    return <String, dynamic>{
      DatabaseConstants.sessionColumnId: item.id,
      DatabaseConstants.sessionColumnName: item.name,
      DatabaseConstants.sessionColumnTimestamp: item.timestamp,
      DatabaseConstants.sessionColumnSessionDeleted: item.deleted ? 1 : 0,
      DatabaseConstants.sessionColumnSessionSent: item.sent ? 1 : 0,
      DatabaseConstants.sessionColumnFKUserId: item.userId
    };
  }

  List toList(List<Session> list) {
    List jsonList = List();
    for (Session session in list) {
      jsonList.add(toMap(session));
    }
    return jsonList;
  }
}
