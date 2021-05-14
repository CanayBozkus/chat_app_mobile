import 'dart:convert';

import 'package:chatapp/utilities/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

class SocketIO {
  IO.Socket _socket = IO.io(
    'http://$serverURI',
    <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    },
  );

  connect(Function onConnectHandler){
    this._socket.onConnect((_) async {
      print('connected ${this._socket.connected} ${this._socket.id}');
      bool success = await onConnectHandler(_socket.id);
      if(!success) _socket.disconnect();
    });
    this._socket.onDisconnect((data) => print('disconnected'));
    this._socket.connect();
  }

  disconnect(phoneNumber, jwt) async {
    await http.post(
      Uri.http(serverURI, 'disconnect-socket'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt'
      },
      body: jsonEncode(<String, String> {
        'phoneNumber': phoneNumber
      })
    );
    this._socket.disconnect();
  }

  setMessageChannelHandler(Function handler){
    this._socket.on('message', handler);
  }

  setMessageSeenChannelHandler(Function handler){
    this._socket.on('message-seen', handler);
  }

  setContactsOnlineStatusChannelHandler(Function handler){
    this._socket.on('online-status', handler);
  }

  subscribeChannel(String channel, Function handler){
    this._socket.on(channel, handler);
  }
}