
import 'package:hive/hive.dart';

part 'alarm.g.dart';

@HiveType(typeId: 0)
class Alarm extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late TimeOfDay time;

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

class TimeOfDay {
  final int hour;
  final int minute;

  TimeOfDay({required this.hour, required this.minute});

  Map<String, dynamic> toJson() => {
        'hour': hour,
        'minute': minute,
      };

  factory TimeOfDay.fromJson(Map<String, dynamic> json) => TimeOfDay(
        hour: json['hour'],
        minute: json['minute'],
      );
}




// Perbaikan simulasi untuk alarm.dart

