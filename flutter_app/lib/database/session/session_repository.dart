import 'package:flutter_app/models/scan_session.dart';
import 'package:flutter_app/models/session_code.dart';

import '../database_provider.dart';

abstract class SessionRepository {
  DBProvider databaseProvider;

  Future<int> insert(Session item);

  Future<int> insertCode(int sessionId, String code);

  Future<int> update(Session item);

  Future<int> delete(int sessionId);

  Future<List<Session>> getAll();

  Future<List<SessionCode>> getCodes(int sessionId);

  Future<int> deleteCode(int sessionId, String sessionCode);

  Future<bool> updateAll(List<int> sessions);
}
