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
    emit(BarcodeScannerScanning(_session));
  }

  Future<void> codeFound(String code) async {
    if (state is BarcodeScannerScanning && _oldCode != code) {
      _oldCode = code;
      if (code.substring(0, 3) == "978" &&
          (code.length == 10 || code.length == 13)) {
        bool connectedToInternet = await _checkInternetConnectivity();
        List<Book> foundedBooks = await _bookRepository.get(_oldCode);
        if (foundedBooks.length == 1 || connectedToInternet) {
          if (foundedBooks.length == 1) {
            emit(BarcodeScannerEanCodeFound(_session, foundedBooks[0]));
            // Future.delayed(const Duration(milliseconds: 500), () {
            //   emit(BarcodeScannerScanning(_session));
            // });
          } else {
            var result = await _bookService.getBook(
                accessToken: "abc", bookCode: _oldCode);
            if (result != null) {
              _bookRepository.insert(result);
            } else {
              emit(BarcodeScannerMessage(
                  _session, "Knjiga sa kodom $_oldCode nije pronadjena"));
            }
          }
        } else {
          emit(BarcodeScannerMessage(_session, "No internet connection"));
        }
      } else {
        if (state is BarcodeScannerScanning &&
            _session.addCode(code) &&
            code.length == 11) {
          try {
            int id = await _sessionRepository.insertCode(_session.id, code);
            emit(BarcodeScannerCode128Found(_session));
            Future.delayed(const Duration(milliseconds: 1000), () {
              emit(BarcodeScannerScanning(_session));
            });
          } catch (ex) {}
        }
      }
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

      emit(BarcodeScannerScanning(_session));
    }
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
