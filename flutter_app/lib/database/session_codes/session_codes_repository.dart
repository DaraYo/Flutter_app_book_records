import 'package:flutter_app/models/session_code.dart';

import '../database_provider.dart';

abstract class SessionCodesRepository {
  DBProvider databaseProvider;

  Future<int> insert(int sessionId, String code);

  Future<List<SessionCode>> getAll(int sessionId);

  Future<int> delete(int sessionId, String code);
}
