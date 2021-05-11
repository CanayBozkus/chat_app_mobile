import 'dart:convert';

import 'package:chatapp/services/database.dart';
import 'package:chatapp/utilities/constants.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:http/http.dart' as http;
import 'package:chatapp/utilities/extension/string.dart';

class DeviceContact {

  List<Map<String, dynamic>> _contacts;

  List<Map<String, dynamic>> get contacts => this._contacts;

  Future<List> _getAllContacts() async {
    Iterable<Contact> contactsRaw = await ContactsService.getContacts();
    return contactsRaw.toList().map((Contact contact){
      return {
        'name': contact.displayName,
        'phoneNumber': contact.phones.firstWhere((element) => element.label == 'mobil').value.getCleanPhoneNumber(),
      };
    }).toList();
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
    List contacts = await this._getAllContacts();
    List registeredContacts = await this._getRegisteredContactsFromCloud(contacts, jwt);
    if(registeredContacts == null){
      print('------- registered contacts returned null handle error ----');
      return;
    }
    this._contacts = contacts.where((contact) => registeredContacts.contains(contact['phoneNumber'].toString().getCleanPhoneNumber())).toList();
    databaseManager.saveContacts(contacts);
  }

  void getRegisteredContacts(){
    this._contacts = databaseManager.getContacts();
  }

  Future<void> checkOnlineContacts(String jwt) async {
    List contactsNumbers = this.contacts.map((e) => e['phoneNumber']).toList();

    try{
      http.Response res = await http.post(
        Uri.http(serverURI, 'check-online-contacts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt'
        },
        body: jsonEncode(<String, List>{
          'contactsNumbers': contactsNumbers,
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