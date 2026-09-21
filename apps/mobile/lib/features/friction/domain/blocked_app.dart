import 'package:flutter/foundation.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';

@immutable
class BlockedApp {
  const BlockedApp({required this.appPackageId, required this.level});

  final String appPackageId;
  final FrictionLevel level;
}
