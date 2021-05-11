
class Message {
  String from;
  String message;
  String to;
  DateTime sendTime;
  bool seen;

  Message({
    this.from,
    this.to,
    this.message,
    this.sendTime,
    this.seen = false
  });

  static fromMap(Map message){
    return Message(
      from: message['from'],
      to: message['to'],
      message: message['message'],
      sendTime: DateTime.parse(message['sendTime']),
      seen: message['seen']
    );
  }

  Map toMap(){
    return {
      "from": this.from,
      "message": this.message,
      "seen": this.seen,
      "sendTime": this.sendTime.toIso8601String(),
      "to": this.to
    };
  }
}
