import 'package:chatapp/models/chat_room.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/utilities/constants.dart';
import 'package:chatapp/widgets/base_textformfield.dart';
import 'package:chatapp/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/utilities/general_provider.dart';
import 'package:chatapp/utilities/extension/string.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = 'ChatScreen';

  ChatScreen({@required this.chatRoom});

  final ChatRoom chatRoom;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatRoom room;
  Message message = Message();
  bool _init = false;
  final _formKey = GlobalKey<FormState>();

  void _customInit(){
    if(this._init) return;

    room = context.watch<GeneralProvider>()
        .chatRooms
        .firstWhere((element) => element == widget.chatRoom, orElse: () => widget.chatRoom);
    context.read<GeneralProvider>().sendMessageSeenInfo(room);

    this._init = true;
  }

  @override
  void initState() {
    context.read<GeneralProvider>().focusedChatRoom = widget.chatRoom;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _customInit();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
              room.name,
              style: kAppbarTitleStyle
          ),
          actions: [
            PopupMenuButton(
              onSelected: (value){
                print(value);
              },
              itemBuilder: (BuildContext context){
                return ['1', '2', '3'].map((e){
                  return PopupMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: room.messages?.length ?? 0,
                itemBuilder: (BuildContext context, int index){
                  return MessageBubble(
                    isMe: room.messages[index]['to'] == room.to,
                    message: room.messages[index],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: BaseTextFormField(
                        maxLines: 3,
                        minLines: 1,
                        onSaved: (String value){
                          message.message = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Material(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        _formKey.currentState.save();

                        if(message.message == '') return;

                        message.sendTime = DateTime.now();
                        message.from= context.read<GeneralProvider>().user.phoneNumber;
                        message.to = room.to.getCleanPhoneNumber();
                        await context.read<GeneralProvider>().sendMessage(message, room);

                        setState(() {
                          message = Message();
                          _formKey.currentState.reset();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.transparent,
                        ),
                        width: 60,
                        height: 50,
                        child: Icon(Icons.send, size: 30, color: Colors.white,),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


