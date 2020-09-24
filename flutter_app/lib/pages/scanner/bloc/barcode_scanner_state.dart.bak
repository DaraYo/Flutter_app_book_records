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
  final bool ean13;
  BarcodeScannerScanning(this.session, this.ean13);

  @override
  // TODO: implement props
  List<Object> get props => [session, ean13];
}

class BarcodeScannerScanOptionChange extends BarcodeScannerState {
  BarcodeScannerScanOptionChange();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BarcodeScannerCodeFound extends BarcodeScannerState {
  BarcodeScannerCodeFound();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BarcodeScannerCode128Found extends BarcodeScannerState {
  final Session session;
  const BarcodeScannerCode128Found(this.session);

  @override
  // TODO: implement props
  List<Object> get props => [session];
}

class BarcodeScannerEanCodeFound extends BarcodeScannerState {
  final Book book;
  final Session session;
  const BarcodeScannerEanCodeFound(this.session, this.book);

  @override
  // TODO: implement props
  List<Object> get props => [book];
}

class BarcodeScannerMessage extends BarcodeScannerState {
  final String message;
  final Session session;
  final bool ean13;

  BarcodeScannerMessage(this.session, this.ean13, this.message);

  @override
  // TODO: implement props
  List<Object> get props => [session, ean13, message];
}
