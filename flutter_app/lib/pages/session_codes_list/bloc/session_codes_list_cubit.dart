import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app/database/session/session_repository.dart';
import 'package:flutter_app/models/session_code.dart';

part 'session_codes_list_state.dart';

class SessionCodesListCubit extends Cubit<SessionCodesListState> {
  List<SessionCode> _sessionCodes;
  int _sessionId;

  final SessionRepository _sessionRepository;

  SessionCodesListCubit(this._sessionId, this._sessionRepository)
      : super(SessionCodesListInitial()) {
    _getSessionCodes();
  }

  Future<void> _getSessionCodes() async {
    try {
      emit(SessionCodesListLoading());
      _sessionCodes = await _sessionRepository.getCodes(_sessionId);
      emit(SessionCodesListLoaded(_sessionCodes));
    } catch (ex) {
      emit(SessionCodesListError("This is error message"));
    }
  }

  Future<void> deleteSessionCode(String sessionCode) async {
    if (state is SessionCodesListLoaded) {
      try {
        int id = await _sessionRepository.deleteCode(_sessionId, sessionCode);
        emit(SessionCodesListItemDeleted());
        _getSessionCodes();
      } catch (ex) {}
    }
  }
}
