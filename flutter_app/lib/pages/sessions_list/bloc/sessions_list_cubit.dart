import 'package:flutter_app/custom/app_exceptions.dart';
import 'package:flutter_app/database/session/session_repository.dart';
import 'package:flutter_app/models/scan_session.dart';
import 'package:flutter_app/pages/sessions_list/bloc/sessions_list_state.dart';
import 'package:flutter_app/services/session_service.dart';
import 'package:flutter_app/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionsListCubit extends Cubit<SessionsListState> {
  List<Session> _sessions;

  final SessionRepository _sessionRepository;
  SessionService _sessionService;

  SessionsListCubit(this._sessionRepository) : super(SessionsListInitial()) {
    _sessionService = SessionService();
    _getSessions();
  }

  Future<void> deleteSession(int sessionId) async {
    if (state is SessionsListLoaded) {
      try {
        int id = await _sessionRepository.delete(sessionId);
        emit(SessionsListItemDeleted());
        _getSessions();
      } catch (ex) {}
    }
  }

  Future<void> _getSessions() async {
    try {
      emit(SessionsListLoading());
      _sessions = await _sessionRepository.getAll();
      emit(SessionsListLoaded(_sessions));
    } catch (ex) {
      emit(SessionsListError("Greška prilikom pribavljanja podataka"));
      Future.delayed(const Duration(milliseconds: 1000), () {
        emit(SessionsListLoaded(_sessions));
      });
    }
  }

  Future<void> synchronizeSessions() async {
    List<Session> listForSync =
        _sessions.where((element) => element.sent == false).toList();
    try {
      var result = await _sessionService.syncSessions(sessions: listForSync);
      if (result == true) {
        List<int> synchronized = new List();
        listForSync.forEach((element) {
          synchronized.add(element.id);
        });
        await _sessionRepository.updateAll(synchronized);
        _getSessions();
      }
    } on UnauthorisedException catch (ex) {
      emit(SessionsListError("This is error message"));
      Future.delayed(const Duration(milliseconds: 1000), () {
        emit(SessionsListLoaded(_sessions));
      });
    }
  }
}
