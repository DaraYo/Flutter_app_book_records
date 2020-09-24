part of 'barcode_scanner_cubit.dart';

abstract class BarcodeScannerState extends Equatable {
  const BarcodeScannerState();
}

class BarcodeScannerInitial extends BarcodeScannerState {
  const BarcodeScannerInitial();

  @override
  List<Object> get props => [];
}

class BarcodeScannerScanning extends BarcodeScannerState {
  final Session session;
  BarcodeScannerScanning(this.session);

  @override
  // TODO: implement props
  List<Object> get props => [session];
}

// class BarcodeScannerScanOptionChange extends BarcodeScannerState {
//   BarcodeScannerScanOptionChange();

//   @override
//   // TODO: implement props
//   List<Object> get props => [];
// }

// class BarcodeScannerCodeFound extends BarcodeScannerState {
//   BarcodeScannerCodeFound();

//   @override
//   // TODO: implement props
//   List<Object> get props => [];
// }

class BarcodeScannerCode128Found extends BarcodeScannerState {
  //extends BarcodeScannerScanning {
  final Session session;
  BarcodeScannerCode128Found(this.session); // : super(session);

  @override
  // TODO: implement props
  List<Object> get props => [session];
}

class BarcodeScannerEanCodeFound extends BarcodeScannerScanning {
  final Book book;
  final Session session;
  BarcodeScannerEanCodeFound(this.session, this.book) : super(session);

  @override
  // TODO: implement props
  List<Object> get props => [book];
}

class BarcodeScannerMessage extends BarcodeScannerScanning {
  final String message;
  final Session session;

  BarcodeScannerMessage(this.session, this.message) : super(session);

  @override
  // TODO: implement props
  List<Object> get props => [session, message];
}
