import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app/database/book/book_repository.dart';
import 'package:flutter_app/database/book/book_repository_imp.dart';
import 'package:flutter_app/database/database_provider.dart';
import 'package:flutter_app/database/session/session_repository.dart';
import 'package:flutter_app/models/book.dart';
import 'package:flutter_app/models/scan_session.dart';
import 'package:flutter_app/services/book_service.dart';
import 'package:flutter_app/utils/storage_util.dart';

part 'barcode_scanner_state.dart';

class BarcodeScannerCubit extends Cubit<BarcodeScannerState> {
  Session _session;
  String _oldCode = "";

  final SessionRepository _sessionRepository;
  BookRepository _bookRepository;
  BookService _bookService;

  BarcodeScannerCubit(this._session, this._sessionRepository)
      : super(BarcodeScannerInitial()) {
    _bookRepository = BookRepositoryImp(DBProvider.instance);
    _bookService = BookService();
  }

  Future<void> messageRead() async {
    emit(BarcodeScannerScanning(_session, StorageUtil.getBool("ean13")));
  }

  Future<void> codeFound(String code) async {
    // an old idea
    // if (state is BarcodeScannerScanning && _session.addCode(code)) {
    //   try {
    //     int id = await _sessionRepository.insertCode(_session.id, code);

    //     emit(BarcodeScannerCode128Found(_session));

    //     Future.delayed(const Duration(milliseconds: 1000), () {
    //       emit(BarcodeScannerScanning(_session));
    //     });
    //   } catch (ex) {}
    // }

    //_________________________________________
    if (state is BarcodeScannerScanning && _oldCode != code) {
      _oldCode = code;
      if (code.substring(0, 3) == "978" &&
          (code.length == 10 || code.length == 13)) {
        bool connectedToInternet = await _checkInternetConnectivity();
        List<Book> foundedBooks = await _bookRepository.get(_oldCode);
        if (foundedBooks.length == 1 || connectedToInternet) {
          if (foundedBooks.length == 1) {
            emit(BarcodeScannerEanCodeFound(_session, foundedBooks[0]));
          } else {
            var result = await _bookService.getBook(
                accessToken: "abc", bookCode: _oldCode);
            if (result != null) {
              print(result);
              _bookRepository.insert(result);
            } else {
              print("Moja poruka = knjiga nije pronadjena");
              emit(BarcodeScannerMessage(_session, StorageUtil.getBool("ean13"),
                  "Knjiga sa kodom $_oldCode nije pronadjena"));
            }
          }
        } else {
          print("Moja poruka u cubitu, nema interneta");
          emit(BarcodeScannerMessage(_session, StorageUtil.getBool("ean13"),
              "No internet connection"));
        }
      } else {
        if (state is BarcodeScannerScanning && _session.addCode(code)) {
          try {
            int id = await _sessionRepository.insertCode(_session.id, code);

            emit(BarcodeScannerCode128Found(_session));

            Future.delayed(const Duration(milliseconds: 1000), () {
              emit(BarcodeScannerScanning(
                  _session, StorageUtil.getBool("ean13")));
            });
          } catch (ex) {}
        }
      }
    }
  }

  Future<void> closeDialog() async {
    if (state is BarcodeScannerEanCodeFound) {
      emit(BarcodeScannerScanning(_session, StorageUtil.getBool("ean13")));
    }
  }

  Future<void> createSession(String name) async {
    if (state is BarcodeScannerInitial) {
      _oldCode = '';
      _session.name = name;
      _session.timestamp = DateTime.now().millisecondsSinceEpoch;
      final id = await _sessionRepository.insert(_session);
      _session.id = id;
      print('Ovo je ID nove sesije: $id');

      emit(BarcodeScannerScanning(_session, StorageUtil.getBool("ean13")));
    }
  }

  Future<void> onScanOptionChange() async {
    bool ean13On = StorageUtil.getBool("ean13") ?? false;
    // emit(BarcodeScannerScanOptionChange());
    StorageUtil.putBool("ean13", !ean13On);
    emit(BarcodeScannerScanning(_session, StorageUtil.getBool("ean13")));
  }

  Future<void> continueScanning() async {
    emit(BarcodeScannerScanning(_session, StorageUtil.getBool("ean13")));
  }

  Future<bool> _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return true;
    }
  }
}
