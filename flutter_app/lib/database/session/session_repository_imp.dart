import 'package:flutter_app/database/database_constants.dart';
import 'package:flutter_app/database/database_provider.dart';
import 'package:flutter_app/database/session/session_dao.dart';
import 'package:flutter_app/database/session/session_repository.dart';
import 'package:flutter_app/database/session_codes/session_codes_repository.dart';
import 'package:flutter_app/database/session_codes/session_codes_repository_imp.dart';
import 'package:flutter_app/models/scan_session.dart';
import 'package:flutter_app/models/session_code.dart';

class SessionRepositoryImp implements SessionRepository {
  @override
  DBProvider databaseProvider;

  SessionCodesRepository _sessionCodesRepository;

  SessionRepositoryImp(this.databaseProvider) {
    _sessionCodesRepository = SessionCodeRepositoryImp(this.databaseProvider);
  }

  // @override
  // Future<int> delete(Session item) async{
  //   await databaseProvider.delete(DatabaseConstants.sessionCodeTable, DatabaseConstants.sessionCodeColSessionId, item.id);
  //   return await databaseProvider.delete(DatabaseConstants.sessionTable, DatabaseConstants.sessionColumnId, item.id);
  // }

  @override
  Future<int> delete(int sessionId) async {
    await databaseProvider.delete(DatabaseConstants.sessionCodeTable,
        DatabaseConstants.sessionCodeColSessionId, sessionId);
    return await databaseProvider.delete(DatabaseConstants.sessionTable,
        DatabaseConstants.sessionColumnId, sessionId);
  }

  @override
  Future<List<Session>> getAll() async {
    // TODO: implement getAll
    final allQueries =
        await databaseProvider.queryAllRows(DatabaseConstants.sessionTable);
    return SessionDao().fromList(allQueries);
  }

  @override
  Future<int> insert(Session item) async {
    // TODO: implement insert
    return await databaseProvider.insert(
        DatabaseConstants.sessionTable, SessionDao().toMap(item));
  }

  @override
  Future<int> update(Session item) async {
    // TODO: implement update
    return await databaseProvider.update(DatabaseConstants.sessionTable,
        DatabaseConstants.sessionColumnId, SessionDao().toMap(item));
  }

  @override
  Future<List<SessionCode>> getCodes(int sessionId) {
    // TODO: implement getCodes
    return _sessionCodesRepository.getAll(sessionId);
  }

  @override
  Future<int> insertCode(int sessionId, String code) {
    // TODO: implement insertCode
    return _sessionCodesRepository.insert(sessionId, code);
  }

  @override
  Future<int> deleteCode(int sessionId, String sessionCode) {
    return _sessionCodesRepository.delete(sessionId, sessionCode);
  }

  @override
  Future<bool> updateAll(List<int> sessions) async {
    return await databaseProvider.updateAll(DatabaseConstants.sessionTable,
        DatabaseConstants.sessionColumnId, sessions);
  }
}
