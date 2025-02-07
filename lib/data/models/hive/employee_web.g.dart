// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_web.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeWebAdapter extends TypeAdapter<EmployeeWeb> {
  @override
  final int typeId = 0;

  @override
  EmployeeWeb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmployeeWeb(
      id: fields[0] as int?,
      name: fields[1] as String,
      role: fields[2] as String,
      fromDate: fields[3] as String,
      toDate: fields[4] as String?,
      status: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EmployeeWeb obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.fromDate)
      ..writeByte(4)
      ..write(obj.toDate)
      ..writeByte(5)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeWebAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
