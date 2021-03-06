import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/home_page.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_app/utils/secure_storage_util.dart';
import 'package:flutter_app/utils/storage_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.getInstance();
  await SecureStorageUtil.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(textTheme: TextTheme(headline1: AppBarTextStyle)),
        textTheme: TextTheme(
            headline1: TitleTextStyle,
            bodyText1: Body1TextStyle,
            button: ButtonTextStyle),
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Bibliotečki fond'),
    );
  }
}
