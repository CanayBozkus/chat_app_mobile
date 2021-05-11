import 'package:chatapp/utilities/constants.dart';
import 'package:flutter/material.dart';

class BaseTextFormField extends StatelessWidget {
  BaseTextFormField({this.hintText, this.secure = false, this.validator, this.onSaved, this.keyboardType = KeyboardTypes.text, this.maxLines = 1, this.minLines});
  final String hintText;
  final bool secure;
  final Function validator;
  final Function onSaved;
  final KeyboardTypes keyboardType;
  final int maxLines;
  final int minLines;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      obscureText: secure,
      style: TextStyle(
        fontSize: 22,
      ),
      keyboardType: kKeyboards[keyboardType],
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
              color: kPrimaryColor,
              width: 1.5
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
              color: kPrimaryColor,
              width: 1.5
          ),
        ),
      ),
    );
  }
}
