import 'dart:async';
import 'dart:io';

import 'package:chatapp/models/chat_room.dart';
import 'package:chatapp/models/hive/hive_chatroom.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/services/contact.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/services/notification_plugin.dart';
import 'package:chatapp/services/sharedPreference.dart';
import 'package:chatapp/services/socketio.dart';
import 'package:chatapp/utilities/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/utilities/extension/string.dart';
import 'package:http/http.dart' as http;
class GeneralProvider with ChangeNotifier {
  User _user;

  List<ChatRoom> _chatRooms = [];
  String _jwt;
  SocketIO _socketIO;
  ChatRoom focusedChatRoom;
  bool _isDataInitialized = false;

  User get user => this._user;
  List<ChatRoom> get chatRooms => this._chatRooms;

  Future<bool> login({User user, bool isRegistering = false}) async {

    this._jwt = await user.login(isRegistering: isRegistering);

    if(this._jwt == null){
      return false;
    }
    SharedPreferences pref = await getPreference();
    pref.setString('jwt-token', this._jwt);
    return true;
  }

  Future<bool> register(User user) async {
    Map registerResult = await user.register();
    if(registerResult['success']){
      bool loginResult = await this.login(user: user, isRegistering: true);
      return loginResult;
    }
    return false;
  }

  Future<void> initializeAppData() async {

    if(this._isDataInitialized) return;

    SharedPreferences pref = await getPreference();

    this._jwt = pref.getString('jwt-token');

    this.getChatRooms();

    this._user = User();
    await this._user.getUserData();

    this.getContacts();

    this.connectSocket();

    notificationPlugin.setListenerForLowerVersions(() {});
    notificationPlugin.setOnNotificationClick((String payload) {});

    this.receiveMessageHandler();
    this.sentMessageSeenHandler();
    this.contactsOnlineStatusHandler();
    
    //this.checkOnlineContacts();

    this._isDataInitialized = true;
  }

  void getContacts() {
    this._user.deviceContact.getRegisteredContacts();
  }

  void getChatRooms(){
    List rooms = databaseManager.getChatRooms();

    if(rooms.isEmpty){
      this._chatRooms = [];

      return;
    }

    rooms.forEach((room) {
      ChatRoom chatRoom = ChatRoom(
        members: room.members,
        createdDate: room.createdDate,
        name: room.name,
        creator: room.creator,
        admins: room.admins,
        isGroup: room.isGroup,
        messages: room.messages,
        to: room.to
      );

      this._chatRooms.add(chatRoom);
    });
  }

  void connectSocket(){
    if(this._socketIO == null){
      this._socketIO = SocketIO();
    }
    this._socketIO.connect((socketID) async {
      bool success = await this.user.setSocketConnectionData(_jwt, socketID);
      if(success){
        //await this.checkOnlineContacts();
      }
      return success;
    });
  }

  void disconnectSocket(){
    this._socketIO.disconnect(this._user.phoneNumber, this._jwt);
  }

  Future<void> sendMessage(Message message, ChatRoom chatRoom) async {
    await chatRoom.sendMessage(message, this._jwt);
    bool isContains = this._chatRooms.contains(chatRoom);
    if(!isContains) this._chatRooms.add(chatRoom);
    notifyListeners();
  }

  void receiveMessageHandler(){
    this._socketIO.setMessageChannelHandler((message) async {
      if(message is List){
        for(Map newMessage in message){
          this._receiveMessageHelper(newMessage);
        }
        return;
      }
      this._receiveMessageHelper(message);
    });
  }

  void sentMessageSeenHandler(){
    this._socketIO.setMessageSeenChannelHandler((data) async {
      await this._sentMessagesHaveBeenSeenHelper(data);
    });
  }

  Future<void> _receiveMessageHelper(Map message) async {
    ChatRoom room = this._chatRooms.firstWhere(
            (element) => element.to == message['from'],
        orElse: () => null
    );
    if(room == null){
      String name = this._user.deviceContact.registeredContacts.firstWhere(
            (element) => element['phoneNumber'] == message['from'],
        orElse: () => {'name': message['from']},
      )['name'];

      room = ChatRoom(
        to: message['from'],
        isGroup: false,
        messages: [],
        name: name,
      );
      this._chatRooms.add(room);
    }
    message['seen'] = true;

    await room.receiveMessage(message, room == this.focusedChatRoom, this._jwt);
    notifyListeners();
  }

  Future<void> refreshContactsAndChatRoomData() async {
    await this._user.deviceContact.refreshRegisteredContacts(this._jwt);
    this._chatRooms.forEach((ChatRoom room) async {
      Map contact = this._user.deviceContact.registeredContacts.firstWhere((element) => element['phoneNumber'].getCleanPhoneNumber() == room.to);
      room.name = contact['name'];
      await room.saveChatRoom();
    });
    notifyListeners();
  }

  ChatRoom getOrCreateChatRoom({@required ChatRoomTypes type, @required String searchValue, Map data}){
    if(type == ChatRoomTypes.direct){
      ChatRoom chatRoom = this._chatRooms.firstWhere(
            (ChatRoom element){
          return element.to == searchValue
              .toString()
              .getCleanPhoneNumber();
        },
        orElse: () => null,
      );
      if(chatRoom == null) {
        if(data.isEmpty){
          throw 'ChatRoom not found and data is not provided';
        }

        chatRoom = ChatRoom(
          to: data['phoneNumber'],
          name: data['name'],
          messages: [],
          isGroup: false,
        );
      }

      return chatRoom;
    }

    return null;
  }

  Future<void> _sentMessagesHaveBeenSeenHelper(Map data) async {
    String receiverPhoneNumber = data['from'];
    DateTime seenTime = DateTime.parse(data['seenTime']);
    ChatRoom room = this._chatRooms.firstWhere((element) => element.to == receiverPhoneNumber);
    room.messages.forEach((element) {
      DateTime sendTime = DateTime.parse(element['sendTime']);
      if(seenTime.isAfter(sendTime) || element['seen'] != true){
        element['seen'] = true;
      }
    });
    await room.saveChatRoom();
    notifyListeners();
  }

  Future<void> sendMessageSeenInfo(ChatRoom room) async {
    if(this._chatRooms.contains(room)) await room.sendMessageSeenInfo(this._jwt);
    notifyListeners();
  }

  Future<void> checkOnlineContacts() async {
    await this._user.deviceContact.checkOnlineContacts(this._jwt);
  }
  
  void contactsOnlineStatusHandler(){
    this._socketIO.setContactsOnlineStatusChannelHandler((data){
      List onlineContacts = data['onlineContacts'];
      print(data);
      this._user.deviceContact.registeredContacts.forEach((contact) {
        if(onlineContacts.contains(contact['phoneNumber'])){
          contact['online'] = true;
        }
      });
    });
  }
}