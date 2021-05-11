import 'package:hive/hive.dart';

part 'hive_chatroom.g.dart';

@HiveType(typeId: 0)
class HiveChatRoom {
  @HiveField(0)
  List<String> members;
  @HiveField(1)
  List<Map> messages;
  @HiveField(2)
  String name;
  @HiveField(3)
  bool isGroup;
  @HiveField(4)
  DateTime createdDate;
  @HiveField(5)
  String creator;
  @HiveField(6)
  List<String> admins;
  @HiveField(7)
  String to;
  @HiveField(8)
  int unseenMessageCount = 0;
}