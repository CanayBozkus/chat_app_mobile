// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_chatroom.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveChatRoomAdapter extends TypeAdapter<HiveChatRoom> {
  @override
  final int typeId = 0;

  @override
  HiveChatRoom read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveChatRoom()
      ..members = (fields[0] as List)?.cast<String>()
      ..messages = (fields[1] as List)
          ?.map((dynamic e) => (e as Map)?.cast<dynamic, dynamic>())
          ?.toList()
      ..name = fields[2] as String
      ..isGroup = fields[3] as bool
      ..createdDate = fields[4] as DateTime
      ..creator = fields[5] as String
      ..admins = (fields[6] as List)?.cast<String>()
      ..to = fields[7] as String
      ..unseenMessageCount = fields[8] as int;
  }

  @override
  void write(BinaryWriter writer, HiveChatRoom obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.members)
      ..writeByte(1)
      ..write(obj.messages)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.isGroup)
      ..writeByte(4)
      ..write(obj.createdDate)
      ..writeByte(5)
      ..write(obj.creator)
      ..writeByte(6)
      ..write(obj.admins)
      ..writeByte(7)
      ..write(obj.to)
      ..writeByte(8)
      ..write(obj.unseenMessageCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveChatRoomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
