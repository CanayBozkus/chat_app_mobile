import 'package:chatapp/utilities/constants.dart';
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  BaseButton({this.backgroundColor = kPrimaryColor, this.text, this.onPressed});
  final Color backgroundColor;
  final String text;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero
        ),
        child: Container(
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(6)
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 28),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 26
            ),
          ),
        )
    );
  }
}
