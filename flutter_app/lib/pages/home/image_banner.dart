import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {
  final String _asset;

  ImageBanner(this._asset);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: 200.0,
      ),
      decoration: BoxDecoration(color: Colors.white),
      child: Image.asset(
        _asset,
        fit: BoxFit.cover,
      ),
    );
  }
}
