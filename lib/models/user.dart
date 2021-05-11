import 'dart:convert';
import 'dart:io';

import 'package:chatapp/models/hive/hive_user.dart';
import 'package:chatapp/services/contact.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/utilities/constants.dart';
import 'package:chatapp/services/sharedPreference.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/utilities/extension/string.dart';

class User {
  User({this.name, this.image, this.phoneNumber});

  String name;
  File image;
  String phoneNumber;
  bool isConnectionDataSet = false;
  DeviceContact deviceContact = DeviceContact();

  Future<Map> register() async {
    try{
      await deviceContact.getAllContacts();
      List contactsPhoneNumbers = deviceContact.allContacts.map((contact) => contact['phoneNumber']).toList();

      http.Response res = await http.post(
        Uri.http(serverURI, 'signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': this.name,
          'phoneNumber': this.phoneNumber,
          'contactsPhoneNumbers': contactsPhoneNumbers,
        }),
      );
      Map response = jsonDecode(res.body);

      if(response['success']){
        final Directory path = await getApplicationDocumentsDirectory();
        if (this.image != null) {
          await this.image.copy('${path.path}/profile.png');
        }

        List registeredContactsPhoneNumbers = response['registeredContactsPhoneNumbers'];

        this.deviceContact.saveRegisteredContacts(registeredContactsPhoneNumbers);

        HiveUser hiveUser = HiveUser();

        hiveUser.phoneNumber = phoneNumber;
        hiveUser.name = name;

        databaseManager.saveUser(hiveUser);
      }
      return response;
    }
    catch(e){
      print('-----Register Error----');
      print(e);
      return {"success": false, "message": "error"};
    }
  }

  Future<String> login({isRegistering}) async {
    try{
      http.Response res = await http.post(
          Uri.http(serverURI, 'login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'phoneNumber': phoneNumber,
          })
      );
      Map response = jsonDecode(res.body);

      if(response['success']){
        if(isRegistering) return response['token'];

        HiveUser hiveUser = HiveUser();

        hiveUser.phoneNumber = response['user']['phoneNumber'];
        hiveUser.name = response['user']['name'];

        databaseManager.saveUser(hiveUser);

        this.deviceContact.refreshRegisteredContacts(response['token']);

        return response['token'];
      }
      return null;
    }
    catch(e){
      print('----Login Error----');
      print(e);
      return null;
    }
  }

  Future<void> getUserData() async {
    final Directory path = await getApplicationDocumentsDirectory();
    HiveUser hiveUser = databaseManager.getUser();

    this.image = File('${path.path}/profile.png');
    this.name = hiveUser.name;

    this.phoneNumber = hiveUser.phoneNumber;
  }

  static Future<void> logout() async {
    SharedPreferences pref = await getPreference();
    await pref.remove('jwt-token');
  }

  Future<bool> setSocketConnectionData(jwt, socketID) async {
    try{
      http.Response res = await http.post(
          Uri.http(serverURI, 'set-socket-connection-data'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(<String, String>{
            'phoneNumber': this.phoneNumber,
            'socketID': socketID
          })
      );
      Map response = jsonDecode(res.body);
      this.isConnectionDataSet = response['success'];
      return response['success'];
    }
    catch(e){
      print('---- setSocketConnectionData --- error');
      print(e);
      return false;
    }
  }
}