import 'dart:convert';
import 'dart:io';

import 'package:chatapp/utilities/constants.dart';
import 'package:chatapp/services/sharedPreference.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/utilities/extension/string.dart';

class User {
  User({this.name, this.image, this.phoneNumber, this.id});

  String id;
  String name;
  File image;
  String phoneNumber;
  bool isConnectionDataSet = false;

  Future<Map> register() async {
    try{
      http.Response res = await http.post(
        Uri.http(serverURI, 'signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': this.name,
          'phoneNumber': this.phoneNumber,
        }),
      );
      Map response = jsonDecode(res.body);
      return response;
    }
    catch(e){
      print('-----Register Error----');
      print(e);
      return null;
    }
  }

  static Future<User> login({String phoneNumber}) async {
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
        SharedPreferences pref = await getPreference();
        await pref.setString('jwt-token', response['token']);
        await pref.setString('name', response['user']['name']);
        await pref.setString('id', response['user']['_id']);
        await pref.setString('phoneNumber', phoneNumber.getCleanPhoneNumber());

        final Directory path = await getApplicationDocumentsDirectory();
        File image = File('$path/profile.png');
        User user = User(phoneNumber: phoneNumber, name: response['user']['name'], id: response['user']['_id'], image: image);
        return user;
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
    SharedPreferences pref = await getPreference();
    final Directory path = await getApplicationDocumentsDirectory();

    this.image = File('${path.path}/profile.png');
    this.name = pref.getString('name');
    this.id = pref.getString('id');
    this.phoneNumber = pref.getString('phoneNumber');
  }

  static Future<void> logout() async {
    SharedPreferences pref = await getPreference();
    await pref.remove('jwt-token');
  }

  static Future<List> findUser(String searchedUser) async {
    http.Response res = await http.get(
        Uri.http(serverURI, 'find-user/$searchedUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
    );
    Map response = jsonDecode(res.body);
    return response['searchResults'];
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