import 'package:flutter/material.dart';
import 'package:flutter_app/common/color_constants.dart';
import 'package:flutter_app/style.dart';

final kHintTextStyle = TextStyle(
  color: Colors.blueGrey,
  fontFamily: FontNameDefault,
);

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: ColorConstants.color5,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);