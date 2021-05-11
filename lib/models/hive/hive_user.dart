import 'package:hive/hive.dart';

part 'hive_user.g.dart';

@HiveType(typeId: 2)
class HiveUser {
  @HiveField(0)
  String name;
  @HiveField(1)
  String phoneNumber;
}