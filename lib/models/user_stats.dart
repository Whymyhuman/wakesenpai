import 'package:hive/hive.dart';

part 'user_stats.g.dart';

@HiveType(typeId: 1)
class UserStats extends HiveObject {
  @HiveField(0)
  int xp;

  @HiveField(1)
  List<String> unlockedIllustrations;

  @HiveField(2)
  List<String> unlockedSounds;

  UserStats({
    required this.xp,
    required this.unlockedIllustrations,
    required this.unlockedSounds,
  });
}