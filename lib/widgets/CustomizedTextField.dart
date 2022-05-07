import 'package:flutter/material.dart';
import 'package:smart_cap/brand_colors.dart';

// ignore: must_be_immutable
class CustomizedTextField extends StatelessWidget {
  CustomizedTextField({
    Key key,
    @required this.controller,
    @required this.hint,
    @required this.textInputType,
    @required this.obscureText,
    this.codeCountry,
    this.widget,
  }) : super(key: key);
  bool codeCountry = false;
  final TextEditingController controller;
  final String hint;
  final TextInputType textInputType;
  final Widget widget;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      textAlign: TextAlign.start,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
              color: BrandColors.colorTextSemiLight, width: 0.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: BrandColors.colorTextSemiLight, width: 0.7),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: BrandColors.colorPrimaryDark, width: 1.2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 0.7),
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        prefixIcon: widget,
      ),
      controller: controller,
    );
  }
}
