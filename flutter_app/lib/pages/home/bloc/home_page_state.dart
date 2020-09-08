part of 'home_page_cubit.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();
}

class HomePageInitial extends HomePageState {
  final String welcomeString;
  final bool isLoggedIn;
  const HomePageInitial(this.welcomeString, this.isLoggedIn);

  @override
  List<Object> get props => [isLoggedIn];
}
