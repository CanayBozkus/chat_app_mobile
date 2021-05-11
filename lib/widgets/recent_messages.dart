import 'package:chatapp/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/utilities/general_provider.dart';
import 'package:provider/provider.dart';

class RecentMessages extends StatelessWidget {
  const RecentMessages({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List chatRooms = context.watch<GeneralProvider>().chatRooms;
    return ListView.builder(
      itemCount: chatRooms.length,
      itemBuilder: (BuildContext context, int index){
        return ChatCard(chatRoom: chatRooms[index],);
      },
    );
  }
}