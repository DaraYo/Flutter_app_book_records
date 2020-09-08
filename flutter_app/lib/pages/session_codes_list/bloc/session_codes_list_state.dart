part of 'session_codes_list_cubit.dart';

abstract class SessionCodesListState extends Equatable {
  const SessionCodesListState();
}

class SessionCodesListInitial extends SessionCodesListState {
  @override
  List<Object> get props => [];
}

class SessionCodesListLoading extends SessionCodesListState {
  const SessionCodesListLoading();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SessionCodesListLoaded extends SessionCodesListState {
  final List<SessionCode> sessionCodes;
  SessionCodesListLoaded(this.sessionCodes);
  @override
  // TODO: implement props
  List<Object> get props => [sessionCodes];
}

class SessionCodesListError extends SessionCodesListState {
  final String message;
  const SessionCodesListError(this.message);

  @override
  List<Object> get props => [];
}

class SessionCodesListItemDeleted extends SessionCodesListState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
