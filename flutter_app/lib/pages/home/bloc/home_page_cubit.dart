import 'package:bloc/bloc.dart';
import 'package:flutter_app/utils/secure_storage_util.dart';
import 'package:flutter_app/utils/storage_util.dart';
import 'package:equatable/equatable.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageInitial("Dobrodošli", false)) {
    checkLoggedInUser();
  }

  Future<void> logout() {
    StorageUtil.putString("token", null);
    SecureStorageUtil.deleteAll();
    emit(HomePageInitial("Dobrodošli", false));
  }

  Future<void> checkLoggedInUser() async {
    print(StorageUtil.getString("token"));
    if (StorageUtil.getString("token") != null) {
      String nameOfUser = await SecureStorageUtil.read("loggedInUserFirstName");
      emit(HomePageInitial("Dobrodošli " + nameOfUser, true));
    }
  }
}
