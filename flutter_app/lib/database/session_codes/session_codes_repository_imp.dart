import 'package:flutter_app/database/database_constants.dart';
import 'package:flutter_app/database/database_provider.dart';
import 'package:flutter_app/database/session_codes/session_codes_dao.dart';
import 'package:flutter_app/database/session_codes/session_codes_repository.dart';
import 'package:flutter_app/models/session_code.dart';

class SessionCodeRepositoryImp implements SessionCodesRepository {
  @override
  DBProvider databaseProvider;

  SessionCodeRepositoryImp(this.databaseProvider);

  @override
  Future<List<SessionCode>> getAll(int sessionId) async {
    final allQueries = await databaseProvider.queryAllRowsByColumnValue(
        DatabaseConstants.sessionCodeTable,
        DatabaseConstants.sessionColumnId,
        sessionId);
    final codes = SessionCodeDao().fromList(allQueries);
    List<String> retVal = List<String>();
    for (SessionCode item in codes) {
      retVal.add(item.code);
    }
    return codes;
  }

  @override
  Future<int> insert(int sessionId, String code) async {
    SessionCode item = SessionCode();
    item.code = code;
    item.sessionId = sessionId;
    return await databaseProvider.insert(
        DatabaseConstants.sessionCodeTable, SessionCodeDao().toMap(item));
  }

  @override
  Future<int> delete(int sessionId, String code) async {
    return await databaseProvider.sessionCodeDelete(
        DatabaseConstants.sessionCodeTable,
        DatabaseConstants.sessionCodeColSessionId,
        DatabaseConstants.sessionCodeColCode,
        sessionId,
        code);
  }
}
