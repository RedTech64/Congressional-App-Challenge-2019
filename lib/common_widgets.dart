import 'package:flutter/material.dart';

class ThemeTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String label;
  final double width;


  ThemeTextField({
    @required this.controller,
    @required this.onChanged,
    @required this.label,
    @required this.width
  });

  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      child: new TextField(
        controller: this.controller,
        onChanged: this.onChanged,
        decoration: new InputDecoration(
          labelText: this.label,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(8.0),
          )
        ),
      ),
    );
  }
}

class SimpleText extends StatelessWidget {
  String text = '';
  bool bold = false;
  double size = 16.0;

  SimpleText(this.text, {
    this.bold,
    this.size,
  });

  Widget build(BuildContext context) {
    return new Text(
      text,
      style: new TextStyle(
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : null,
      ),
    );
  }

}

class ThemeButton  extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double size;
  final Icon icon;

  ThemeButton({this.text, this.onPressed,this.size,this.icon});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
            this.text,
            style: new TextStyle(
              fontSize: this.size,
            ),
          ),
          if(this.icon != null)
            this.icon
        ],
      ),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.green[400],
      textColor: Colors.white,
    );
  }

}