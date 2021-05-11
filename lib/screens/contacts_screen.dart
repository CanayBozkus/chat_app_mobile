import 'package:chatapp/models/chat_room.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/utilities/constants.dart';
import 'package:chatapp/utilities/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/utilities/extension/string.dart';

class ContactsScreen extends StatelessWidget {
  
  Future<void> refresh(BuildContext context) async {
    await context.read<GeneralProvider>().refreshContactsAndChatRoomData();
  }

  static const routeName = 'ContactsScreen';
  @override
  Widget build(BuildContext context) {
    List<Map<String, Object>> contacts = context.watch<GeneralProvider>().user.deviceContact.registeredContacts;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text(
            '${contacts.length} Contacts',
            style: kAppbarTitleStyle
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){

            },
          ),
          PopupMenuButton(
            onSelected: (key) async {
              switch(kContactsScreenDropdownValues[key]){
                case 0: return await refresh(context);
              }
            },
            itemBuilder: (BuildContext context){
              return kContactsScreenDropdownValues.keys.map((key){
                return PopupMenuItem(
                  value: key,
                  child: Text(key),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(contacts[index]['name']),
            onTap: (){
              ChatRoom room = context.read<GeneralProvider>().getOrCreateChatRoom(
                type: ChatRoomTypes.direct,
                searchValue: contacts[index]['phoneNumber'],
                data: contacts[index],
              );
              Navigator.pushReplacementNamed(context, ChatScreen.routeName, arguments: room);
            },
          );
        },
      ),
    );
  }
}
