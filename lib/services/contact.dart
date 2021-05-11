import 'dart:convert';

import 'package:chatapp/services/database.dart';
import 'package:chatapp/utilities/constants.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:http/http.dart' as http;
import 'package:chatapp/utilities/extension/string.dart';

class DeviceContact {

  List<Map<String, dynamic>> registeredContacts = [];
  List<Map<String, dynamic>> allContacts = [];

  Future<void> getAllContacts() async {
    Iterable<Contact> contactsRaw = await ContactsService.getContacts();
    this.allContacts = contactsRaw.toList().map((Contact contact){
      return {
        'name': contact.displayName,
        'phoneNumber': contact.phones.firstWhere((element) => element.label == 'mobil').value.getCleanPhoneNumber(),
      };
    }).toList();
  }

  void saveRegisteredContacts(List registeredContactsPhoneNumbers){
    List registeredContacts = allContacts.where(
            (contact) => registeredContactsPhoneNumbers.contains(contact['phoneNumber'].toString().getCleanPhoneNumber())
    ).toList();
    databaseManager.saveContacts(registeredContacts);
  }

  Future<List> _getRegisteredContactsFromCloud(List contacts, String jwt) async {
    try{
      http.Response res = await http.post(
        Uri.http(serverURI, 'get-registered-users-from-contacts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt'
        },
        body: jsonEncode(<String, List>{
          'contacts': contacts.map((e) => e['phoneNumber']).toList(),
        }),
      );
      Map response = jsonDecode(res.body);
      return response['success'] ? response['users'] : null;
    }
    catch(e){
      print('----- get-registered-users-from-contacts Error----');
      print(e);
      return null;
    }
  }

  refreshRegisteredContacts(String jwt) async {
    if(this.allContacts.isEmpty){
      await this.getAllContacts();
    }
    List registeredContacts = await this._getRegisteredContactsFromCloud(allContacts, jwt);
    if(registeredContacts == null){
      print('------- registered contacts returned null handle error ----');
      return;
    }
    this.saveRegisteredContacts(registeredContacts);
    //this._conta = contacts.where((contact) => registeredContacts.contains(contact['phoneNumber'].toString().getCleanPhoneNumber())).toList();
    //databaseManager.saveContacts(contacts);
  }

  void getRegisteredContacts(){
    this.registeredContacts = databaseManager.getContacts();
  }

  Future<void> checkOnlineContacts(String jwt) async {
    //List contactsNumbers = this.contacts.map((e) => e['phoneNumber']).toList();

    try{
      http.Response res = await http.post(
        Uri.http(serverURI, 'check-online-contacts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt'
        },
        body: jsonEncode(<String, List>{
          //'contactsNumbers': contactsNumbers,
        }),
      );
      Map response = jsonDecode(res.body);
    }
    catch(e){
      print('----- check-online-contacts Error----');
      print(e);
    }
  }
}