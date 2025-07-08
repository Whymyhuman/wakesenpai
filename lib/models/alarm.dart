import 'package:hive/hive.dart';

part 'alarm.g.dart';

@HiveType(typeId: 0)
class Alarm extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int hour;

  @HiveField(2)
  int minute;

  @HiveField(3)
  bool isActive;

  @HiveField(4)
  bool isRepeatingDaily;

  @HiveField(5)
  String soundPath;

  @HiveField(6)
  String challengeType;

  Alarm({
    required this.id,
    required this.hour,
    required this.minute,
    required this.isActive,
    required this.isRepeatingDaily,
    required this.soundPath,
    required this.challengeType,
  });

  String get timeString => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}