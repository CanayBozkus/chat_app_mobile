import 'package:chatapp/utilities/constants.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({@required this.isMe, this.message});
  final bool isMe;
  final Map message;
  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.parse(message['sendTime']);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.only(right: isMe ? 0 : 40, left: isMe ? 40 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                topRight:  isMe ? Radius.circular(0) : Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: kPrimaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['message'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${time.hour}:${time.minute}',
                      style: TextStyle(
                          color: Colors.white,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(width: 10,),
                    isMe
                        ? Icon(
                      message['seen'] ? Icons.check_circle : Icons.check_circle_outline,
                    )
                        : SizedBox.shrink(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}