import 'package:chatapp/models/chat_room.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/utilities/general_provider.dart';

class ChatCard extends StatelessWidget {
  ChatCard({@required this.chatRoom});
  final ChatRoom chatRoom;
  @override
  Widget build(BuildContext context) {
    bool isLastMessageMine = chatRoom.messages[0]['to'] == chatRoom.to;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ]
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/launcher_icon.png'),
          radius: 30,
        ),
        title: Text(
          chatRoom.name ?? chatRoom.to,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Row(
          children: [
            isLastMessageMine
                ? Icon(chatRoom.messages[0]['seen'] ? Icons.check_circle : Icons.check_circle_outline,)
                : SizedBox.shrink(),
            isLastMessageMine
                ? SizedBox(width: 5,)
                : SizedBox.shrink(),
            Expanded(
              child: Text(
                chatRoom.messages[0]['message'],
                style: TextStyle(
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            chatRoom.unseenMessageCount != 0 ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor
              ),
              padding: EdgeInsets.all(6),
              child: Text(
                chatRoom.unseenMessageCount.toString(),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ) : SizedBox.shrink(),
          ],
        ),
        onTap: () async {
          await Navigator.pushNamed(context, ChatScreen.routeName, arguments: chatRoom);
          context.read<GeneralProvider>().focusedChatRoom = null;
        },
      ),
    );
  }
}