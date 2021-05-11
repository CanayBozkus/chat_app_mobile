// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_registered_contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveRegisteredContactAdapter extends TypeAdapter<HiveRegisteredContact> {
  @override
  final int typeId = 1;

  @override
  HiveRegisteredContact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveRegisteredContact()
      ..name = fields[0] as String
      ..phoneNumber = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, HiveRegisteredContact obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveRegisteredContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
