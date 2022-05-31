import 'package:flutter/material.dart';

class TaxiButton extends StatelessWidget {
  final String? title;
  final Color? color;
  final VoidCallback onPressed;

  const TaxiButton({Key? key, this.title,required this.onPressed, this.color})
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
        child: Center(
          child: Text(
            title!,
            style: const TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
          ),
        ),
      ),
    );
  }
}
