import 'package:chatapp/screens/main_screen.dart';
import 'package:chatapp/screens/registration_screen.dart';
import 'package:chatapp/utilities/constants.dart';
import 'package:chatapp/widgets/base_button.dart';
import 'package:chatapp/widgets/base_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/models/user.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/utilities/general_provider.dart';
import 'package:chatapp/utilities/extension/string.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = 'LoginScreen';
  final _formKey = GlobalKey<FormState>();
  final User _user = User();
  @override
  Widget build(BuildContext context) {
    String phoneNumber;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ChatApp',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: kPrimaryColor,
                ),
              ),
              SizedBox(height: 30,),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      BaseTextFormField(
                        hintText: 'Phone Number',
                        keyboardType: KeyboardTypes.phone,
                        onSaved: (String value){
                          _user.phoneNumber = value.getCleanPhoneNumber();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              BaseButton(
                text: 'Login',
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    _formKey.currentState.save();
                    bool result = await context.read<GeneralProvider>().login(user: _user);
                    if(result){
                      Navigator.pushReplacementNamed(context, MainScreen.routeName);
                    }
                  }
                },
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, RegistrationScreen.routeName);
                },
                child: Text(
                  'Haven\'t registered? Register now.',
                  style: TextStyle(
                    fontSize: 18,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
