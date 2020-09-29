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
