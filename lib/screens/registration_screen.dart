import 'dart:io';

import 'package:chatapp/models/user.dart';
import 'package:chatapp/screens/main_screen.dart';
import 'package:chatapp/utilities/constants.dart';
import 'package:chatapp/widgets/base_button.dart';
import 'package:chatapp/widgets/base_dropdownfield.dart';
import 'package:chatapp/widgets/base_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chatapp/utilities/extension/string.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/utilities/general_provider.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = 'RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final User _user = User();
  final _formKey = GlobalKey<FormState>();
  bool _isCreating = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Register',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: kPrimaryColor,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      CircleAvatar(
                        radius: 80,
                        child: GestureDetector(
                          onTap: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.getImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              _user.image = File(pickedFile.path);

                            } else {
                              print('No image selected.');
                            }
                            setState(() {

                            });
                          },
                          child: ClipOval(
                            child: _user.image == null
                                ?
                            Image.asset('assets/images/avatar.png')
                                :
                            Image.file(
                              _user.image,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BaseTextFormField(
                        hintText: 'Name',
                        onSaved: (String value){
                          _user.name = value;
                        },
                        validator: (String value){
                          if(value.isEmpty){
                            return 'Please enter your name.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BaseTextFormField(
                        hintText: 'Phone Number',
                        keyboardType: KeyboardTypes.phone,
                        onSaved: (String value){
                          _user.phoneNumber = value.getCleanPhoneNumber();
                        },
                        validator: (String value){
                          value = value.getCleanPhoneNumber();
                          if(value.isEmpty){
                            return 'Please enter your phone number.';
                          }
                          else if(value.length < 10){
                            return 'Invalid phone number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _isCreating ? CircularProgressIndicator() : BaseButton(
                text: 'Register',
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    setState(() {
                      _isCreating = true;
                    });
                    _formKey.currentState.save();
                    bool result = await context.read<GeneralProvider>().register(_user);

                    if(result){
                      return Navigator.pushReplacementNamed(context, MainScreen.routeName);
                    }
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('error'),
                        );
                      },
                    );
                    setState(() {
                      _isCreating = false;
                    });
                  }
                },
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
