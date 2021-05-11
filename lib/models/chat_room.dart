import 'dart:convert';

import 'package:chatapp/models/hive/hive_chatroom.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/services/notification_plugin.dart';
import 'package:chatapp/services/sharedPreference.dart';
import 'package:chatapp/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom {
  String creator;
  List<String> admins;
  List members;
  List<Map> messages = [];
  String name;
  bool isGroup;
  DateTime createdDate;
  String to;
  int unseenMessageCount = 0;

  ChatRoom({
    this.members,
    this.createdDate,
    this.creator,
    this.admins,
    this.name,
    this.isGroup,
    this.messages,
    this.to
  });

  sendMessage(Message message, jwt) async {
    try{
      print(message.toMap());
      http.Response res = await http.post(
          Uri.http(serverURI, 'send-message'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(message.toMap())
      );

      Map response = jsonDecode(res.body);
      this.messages.insert(0, message.toMap());
      await this.saveChatRoom();
      return response;
    }
    catch(e){
      print('---- send message error---');
      print(e);
      return false;
    }
  }

  Future<void> receiveMessage(Map message, bool isFocused, String jwt) async {
    this.messages.insert(0, message);
    await this.saveChatRoom();

    if(isFocused){
      this.sendMessageSeenInfo(jwt);
    }
    else {
      this.unseenMessageCount++;
      notificationPlugin.showNotification(
        id: 0,
        title: this.name,
        body: message['message'],
        payload: message['from'],
      );
    }
  }

  Future<void> saveChatRoom() async {
    Map<String, dynamic> hiveRoomData = databaseManager.getChatRoom(to: to);
    HiveChatRoom room;

    if(hiveRoomData['room'] == null){
      print('--no room $name $to');
      room = HiveChatRoom();
    }
    else {
      room = hiveRoomData['room'];
    }

    room.to = this.to;
    room.isGroup = this.isGroup;
    room.name = this.name;
    room.messages = this.messages;
    room.admins = this.admins;
    room.creator = this.creator;
    room.createdDate = this.createdDate;
    room.members = this.members;

    await databaseManager.saveChatRoom(index: hiveRoomData['index'], room: room);
  }

  Future<void> sendMessageSeenInfo(String jwt) async {
    http.Response res = await http.post(
      Uri.http(serverURI, 'send-message-seen-info'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt'
      },
      body: jsonEncode(<String, String>{
        'to': this.to,
        'seenTime': DateTime.now().toIso8601String(),
      })
    );
    this.unseenMessageCount = 0;
    print('saw message ${this.to}');
    Map response = jsonDecode(res.body);
  }
}