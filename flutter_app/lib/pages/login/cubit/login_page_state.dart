part of 'login_page_cubit.dart';

abstract class LoginPageState extends Equatable {
  const LoginPageState();
}

class LoginPageInitial extends LoginPageState {
  final bool rememberMe;
  const LoginPageInitial(this.rememberMe);

  @override
  // TODO: implement props
  List<Object> get props => [rememberMe];
}

class LoginPageWithoutData extends LoginPageState {
  const LoginPageWithoutData();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginPageWithRememberMe extends LoginPageState {
  final bool _rememberMe;
  const LoginPageWithRememberMe(this._rememberMe);

  @override
  // TODO: implement props
  List<Object> get props => [_rememberMe];
}

class LoginIsLoading extends LoginPageState {
  const LoginIsLoading();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginSuccess extends LoginPageState {
  const LoginSuccess();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginError extends LoginPageState {
  final String message;
  const LoginError(this.message);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class LoginPageWithData extends LoginPageState {
  final List<AuthDto> users;
  const LoginPageWithData(this.users);

  @override
  // TODO: implement props
  List<Object> get props => [users];
}
