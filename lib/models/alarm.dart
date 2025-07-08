import 'package:hive/hive.dart';
import 'package:flutter/material.dart' as material;

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

class TimeOfDayCustom {
  final int hour;
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
}





