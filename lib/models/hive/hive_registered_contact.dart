import 'package:hive/hive.dart';

part 'hive_registered_contact.g.dart';

@HiveType(typeId: 1)
class HiveRegisteredContact {
  @HiveField(0)
  String name;
  @HiveField(1)
  String phoneNumber;
}