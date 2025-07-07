
import 'package:hive/hive.dart';

part 'user_stats.g.dart';

@HiveType(typeId: 2)
class UserStats extends HiveObject {
  @HiveField(0)
  late int xp;

  @HiveField(1)
  late List<String> unlockedIllustrations;

  @HiveField(2)
  late List<String> unlockedSounds;

  UserStats({
    required this.xp,
    required this.unlockedIllustrations,
    required this.unlockedSounds,
  });
}


