import 'package:flutter/material.dart';

class AvailabilityButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPressed;

  const AvailabilityButton({Key key, this.title, this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      color: color,
      textColor: Colors.white,
      child: SizedBox(
        height: 50,
        width: 200,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),
          ),
        ),
      ),
    );
  }
}
