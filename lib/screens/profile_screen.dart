import 'dart:io';

import 'package:chatapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/utilities/general_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = 'ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    User user = context.watch<GeneralProvider>().user;
    print(user.image);
    return Scaffold(
      body: Column(
        children: [
          CircleAvatar(
            radius: 80,
            child: GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final pickedFile = await picker.getImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  user.image = File(pickedFile.path);

                } else {
                  print('No image selected.');
                }
                setState(() {

                });
              },
              child: ClipOval(
                child: user.image == null
                    ?
                Image.asset('assets/images/avatar.png')
                    :
                Image.file(
                  user.image,
                ),
              ),
            ),
          ),
          Text(user.phoneNumber),
        ],
      ),
    );
  }
}
