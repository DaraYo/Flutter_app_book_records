import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/color_constants.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/database/database_provider.dart';
import 'package:flutter_app/database/session/session_repository_imp.dart';
import 'package:flutter_app/models/book.dart';
import 'package:flutter_app/models/scan_session.dart';
import 'package:flutter_app/pages/scanner/bloc/barcode_scanner_cubit.dart';
import 'package:flutter_app/pages/shared/button_primary.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_app/utils/storage_util.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:qr_mobile_vision/qr_mobile_vision.dart';

import 'package:vibration/vibration.dart';

class BarcodeScannerPage extends StatefulWidget {
  BarcodeScannerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  FToast fToast;
  static GlobalKey previewContainer = new GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color _scannerBorderDefaultColor = Colors.white70;
  final Color _scannerBorderCodeFoundColor = Colors.green;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    fToast = FToast(context);
  }

  final _sessionNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BlocProvider(
        create: (context) => BarcodeScannerCubit(
            Session(), SessionRepositoryImp(DBProvider.instance)),
        child: BlocConsumer<BarcodeScannerCubit, BarcodeScannerState>(
          listener: (context, state) {
            if (state is BarcodeScannerEanCodeFound) {
              _showBookInfoToast(state.book);
            } else if (state is BarcodeScannerMessage) {
              _showMessageToast(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is BarcodeScannerCode128Found) {
              return buildScannerContainer(
                  context, _scannerBorderCodeFoundColor, state.session);
            } else if (state is BarcodeScannerScanning) {
              return buildScannerContainer(
                  context, _scannerBorderDefaultColor, state.session);
            } else {
              return buildSessionFormPage(context);
            }
          },
        ),
      ),
    );
  }

  Widget buildScannerContainer(
      BuildContext context, Color borderColor, Session scanSession) {
    var scanFormats = [BarcodeFormats.CODE_128];
    if (StorageUtil.getBool("ean13") ?? false) {
      scanFormats.add(BarcodeFormats.EAN_13);
    }
    print(scanFormats);
    if (borderColor == _scannerBorderCodeFoundColor) {
      if (StorageUtil.getBool("shortBeep") ?? false) {
        FlutterBeep.beep();
      }
      if (StorageUtil.getBool("vibration") ?? false) {
        Vibration.vibrate();
      }
    }
    return RepaintBoundary(
      key: previewContainer,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.3,
            ),
            extendBodyBehindAppBar: true,
            body: Container(
              height: MediaQuery.of(context).size.height * 1,
              child: QrCamera(
                fit: BoxFit.cover,
                qrCodeCallback: (code) {
                  final scannerCubit = context.bloc<BarcodeScannerCubit>();
                  scannerCubit.codeFound(code);
                },
                formats: scanFormats,
                notStartedBuilder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 1,
                    width: MediaQuery.of(context).size.height * 1,
                    color: Colors.blueGrey,
                    child: Text(""),
                  );
                },
                offscreenBuilder: (context) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Container(
              height: 300,
              width: 300,
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                color: Color.fromARGB(50, 255, 255, 255),
              ),
            ),
          ),
          new Container(
            alignment: Alignment.topCenter,
            padding: new EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.8,
                right: 20.0,
                left: 20.0),
            child: new Container(
              height: 120.0,
              width: MediaQuery.of(context).size.width,
              child: new Card(
                color: Color.fromARGB(120, 255, 255, 255),
                elevation: 4.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      scanSession.name,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Skenirano: ${scanSession.scannedCodes.length}',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      scanSession.scannedCodes.length > 0
                          ? scanSession.scannedCodes.last
                          : "",
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  createSession(BuildContext context) {
    if (_formKey.currentState.validate()) {
      final scannerCubit = context.bloc<BarcodeScannerCubit>();
      scannerCubit.createSession(_sessionNameController.text);
    }
  }

  Widget buildSessionFormPage(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: new EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints.expand(
              height: 150.0,
            ),
            decoration: BoxDecoration(color: Colors.white),
            child: Image.asset(
              "assets/images/ic_lanucher.png",
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(height: 30),
          Text(
            "Kreiranje nove sesije",
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50),
          _buildSessionNameField(),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonPrimary("Kreiraj", ColorConstants.color2,
                  MediaQuery.of(context).size.width / 2 - 30, () {
                createSession(context);
              }),
              SizedBox(width: 20),
              ButtonPrimary(
                "Otkaži",
                ColorConstants.color4,
                MediaQuery.of(context).size.width / 2 - 30,
                () {
                  Navigator.pop(context);
                },
              )
            ],
          )
        ],
      ),
    );
  }

  void _showMessageToast(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blueGrey[600],
        textColor: Colors.white,
        fontSize: 18.0);
  }

  void _showBookInfoToast(Book book) {
    Widget toastWithButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: ColorConstants.color2,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              book.title,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              book.author1,
              style: TextStyle(color: ColorConstants.color2),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Jezik",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        book.language,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Objavljena",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        book.publishedDate,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Broj stranica",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        book.pageCount.toString(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    fToast.showToast(
      child: toastWithButton,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 1),
    );
  }

  String sessionNameValidator(String value) {
    if (value.isEmpty)
      return '*Ovo polje je obavezno';
    else
      return null;
  }

  Widget _buildSessionNameField() {
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextFormField(
              controller: _sessionNameController,
              validator: sessionNameValidator,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: FontNameDefault,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 14.0),
                hintText: "Naziv sesije",
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _sessionNameController.dispose();
    super.dispose();
  }
}
