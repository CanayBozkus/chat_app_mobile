import 'package:chatapp/utilities/constants.dart';
import 'package:flutter/material.dart';

class BaseDropdownField extends StatelessWidget {
  BaseDropdownField({this.value, this.hint, this.categories, this.onChanged, this.validator,});
  final List categories;
  final String value;
  final String hint;
  final Function onChanged;
  final Function validator;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text(hint),
      style: TextStyle(
        fontSize: 22.0,
      ),
      value: value,
      items: categories.map((e){
        return DropdownMenuItem(
          value: e,
          child: Container(
            child: Text(
              e,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
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
      icon: Icon(Icons.arrow_drop_down, color: kPrimaryColor,),
      iconSize: 30,
      validator: validator,
    );
  }
}
