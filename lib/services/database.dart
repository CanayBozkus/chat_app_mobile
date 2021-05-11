import 'dart:io';
import 'package:chatapp/models/hive/hive_chatroom.dart';
import 'package:chatapp/models/hive/hive_registered_contact.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Database {
  Box _chatRoom;
  Box _registeredContact;
  initializeDatabase() async {
    Directory document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);

    Hive.registerAdapter(HiveChatRoomAdapter());
    Hive.registerAdapter(HiveRegisteredContactAdapter());

    _chatRoom = await Hive.openBox('ChatRoom');
    _registeredContact = await Hive.openBox('RegisteredContact');
  }

  List getChatRooms(){
    return _chatRoom.values.toList();
  }

  saveContacts(List contacts){
    _registeredContact.clear();
    contacts.forEach((contact){
      HiveRegisteredContact newContact = HiveRegisteredContact();
      newContact.phoneNumber = contact['phoneNumber'];
      newContact.name = contact['name'];
      _registeredContact.add(newContact);
    });
  }

  List<Map<String, dynamic>> getContacts(){
    List<Map<String, dynamic>> contacts = [];
    _registeredContact.values.forEach((contact){
      contacts.add({'name': contact.name, 'phoneNumber': contact.phoneNumber, 'online': false});
    });
    return contacts;
  }

  Map<String, dynamic> getChatRoom({@required to}){
    HiveChatRoom room;

    room = _chatRoom.values.firstWhere(
          (element) => element.to == to,
      orElse: () => null,
    );


    if(room == null){
      return {'index': null, 'room': null};
    }

    int index = _chatRoom.values.toList().indexOf(room);

    return {'index': index, 'room': room};
  }

  Future<void> saveChatRoom({index, room}) async {
    if(index == null){
      await _chatRoom.add(room);
    }
    else {
      await _chatRoom.putAt(index, room);
    }
  }
  clear(){
    _chatRoom.clear();
  }
}

Database databaseManager = Database();