import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/scan_session.dart';

abstract class SessionsListState extends Equatable {
  const SessionsListState();
}

class SessionsListInitial extends SessionsListState {
  const SessionsListInitial();

  @override
  List<Object> get props => [];
}

class SessionsListLoading extends SessionsListState {
  const SessionsListLoading();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SessionsListLoaded extends SessionsListState {
  final List<Session> sessions;
  SessionsListLoaded(this.sessions);
  @override
  // TODO: implement props
  List<Object> get props => [sessions];
}

class SessionsListError extends SessionsListState {
  final String message;
  const SessionsListError(this.message);

  @override
  List<Object> get props => [];
}

class SessionsListItemDeleted extends SessionsListState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
