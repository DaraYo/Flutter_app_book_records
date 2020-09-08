import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {

  final String _text;
  final Color _color;
  final double _minWidth;
  final VoidCallback _onPressed;

  ButtonPrimary(this._text, this._color, this._minWidth, this._onPressed);


  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: _minWidth,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        onPressed: _onPressed,
        color: _color,
        elevation: 5,
        child:  Text(
          _text,
          style: Theme.of(context).textTheme.button,
        ),
        padding: EdgeInsets.all(20.0),
      ),
    );
  }

}