import 'package:hive/hive.dart';

part 'alarm.g.dart';

@HiveType(typeId: 0)
class Alarm extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late TimeOfDayCustom time;

  @HiveField(2)
  late bool isActive;

  @HiveField(3)
  late bool isRepeatingDaily;

  @HiveField(4)
  late String soundPath;

  @HiveField(5)
  late String challengeType;

  Alarm({
    required this.id,
    required this.time,
    required this.isActive,
    required this.isRepeatingDaily,
    required this.soundPath,
    required this.challengeType,
  });
}

@HiveType(typeId: 1)
class TimeOfDayCustom extends HiveObject {
  @HiveField(0)
  final int hour;

  @HiveField(1)
  final int minute;

  TimeOfDayCustom({required this.hour, required this.minute});

  Map<String, dynamic> toJson() => {
        'hour': hour,
        'minute': minute,
      };

  factory TimeOfDayCustom.fromJson(Map<String, dynamic> json) => TimeOfDayCustom(
        hour: json['hour'],
        minute: json['minute'],
      );

  @override
  String toString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}