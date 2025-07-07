// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_db_service.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeOfDayAdapterAdapter extends TypeAdapter<TimeOfDayAdapter> {
  @override
  final int typeId = 1;

  @override
  TimeOfDayAdapter read(BinaryReader reader) {
    return TimeOfDayAdapter();
  }

  @override
  void write(BinaryWriter writer, TimeOfDayAdapter obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeOfDayAdapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
