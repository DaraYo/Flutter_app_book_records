import 'package:flutter/material.dart';

import 'package:qr_mobile_vision/qr_mobile_vision.dart';
import 'package:flutter_app/utils/storage_util.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static final _possibleFormats = BarcodeFormats.values.toList()
    ..removeWhere(
        (e) => e != BarcodeFormats.EAN_13 && e != BarcodeFormats.CODE_128);

  @override
  Widget build(BuildContext context) {
    var contentList = <Widget>[];
    _possibleFormats.forEach((element) => print(element.index));
    contentList.add(
      ListTile(
        title: Text("Opcije barkod skenera"),
        dense: true,
        enabled: false,
      ),
    );
    contentList.addAll(
      _possibleFormats.map(
        (format) => CheckboxListTile(
          value: format == BarcodeFormats.CODE_128
              ? true
              : StorageUtil.getBool("ean13") ?? false,
          onChanged: format == BarcodeFormats.CODE_128
              ? null
              : (i) {
                  print(i);
                  StorageUtil.putBool("ean13", i);
                  setState(() {});
                },
          title: Text(format == BarcodeFormats.CODE_128
              ? "Skeniranje u sesijama"
              : "Prikaži detalje o knjizi"),
        ),
      ),
    );
    contentList.addAll(
      [
        ListTile(
          title: Text("Signalizacija"),
          dense: true,
          enabled: false,
        ),
        CheckboxListTile(
          title: Text("Vibracija"),
          value: StorageUtil.getBool("vibration") ?? false,
          onChanged: (checked) {
            StorageUtil.putBool("vibration", checked);
            setState(() {});
          },
        ),
        CheckboxListTile(
          title: Text("Kratak ton"),
          value: StorageUtil.getBool("shortBeep") ?? false,
          onChanged: (checked) {
            StorageUtil.putBool("shortBeep", checked);
            setState(() {});
          },
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Podešavanja'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: contentList,
      ),
    );
  }
}
