import 'package:flutter/material.dart';

const serverURI = '10.0.2.2:3000';

const kPrimaryColor = Color(0xff0cb5ed);

const kAppbarTitleStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.5,
);

enum KeyboardTypes {
  email,
  number,
  text,
  phone
}

const kKeyboards = {
  KeyboardTypes.number: TextInputType.number,
  KeyboardTypes.text: TextInputType.text,
  KeyboardTypes.email: TextInputType.emailAddress,
  KeyboardTypes.phone: TextInputType.phone
};

const kMainScreenFloatingActionButtonIcons = {
  0: Icon(Icons.messenger),
  1: Icon(Icons.group_add),
};

const kMainScreenDropdownValues = {
  'Profile': 0
};

const kContactsScreenDropdownValues = {
  'Refresh': 0
};

enum ChatRoomTypes {
  direct,
  group
}