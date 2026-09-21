import 'package:homeo/core/local_db/app_database.dart';
import 'package:homeo/core/local_db/database_provider.dart';
import 'package:homeo/core/time/clock.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';
import 'package:homeo/features/friction/domain/emergency.dart';
import 'package:homeo/features/settings/domain/user_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_repository.g.dart';

abstract interface class SettingsRepository {
  Future<UserSettings> load();
  Stream<UserSettings> watch();
  Future<void> save(UserSettings settings);
}

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db, this._clock);

  static const _rowId = 'local';

  final AppDatabase _db;
  final Clock _clock;

  @override
  Future<UserSettings> load() async {
    final row = await (_db.select(
      _db.userSettingsTable,
    )..where((r) => r.id.equals(_rowId))).getSingleOrNull();
    return row == null ? UserSettings.defaults : _toDomain(row);
  }

  @override
  Stream<UserSettings> watch() {
    return (_db.select(_db.userSettingsTable)
          ..where((r) => r.id.equals(_rowId)))
        .watchSingleOrNull()
        .map((row) => row == null ? UserSettings.defaults : _toDomain(row));
  }

  @override
  Future<void> save(UserSettings settings) async {
    // toCompanion(false): keep explicit NULLs (see FocusSession repository).
    await _db
        .into(_db.userSettingsTable)
        .insertOnConflictUpdate(
          UserSettingsRow(
            id: _rowId,
            defaultFrictionLevel: settings.defaultFrictionLevel.code,
            emergencyLimitPerMonth: EmergencyQuota.clampLimit(
              settings.emergencyLimitPerMonth,
            ),
            streakBreakAckedRunEnd: settings.streakBreakAckedRunEnd,
            updatedAt: _clock.now(),
          ).toCompanion(false),
        );
  }

  UserSettings _toDomain(UserSettingsRow row) {
    return UserSettings(
      defaultFrictionLevel: FrictionLevel.fromCode(row.defaultFrictionLevel),
      emergencyLimitPerMonth: EmergencyQuota.clampLimit(
        row.emergencyLimitPerMonth,
      ),
      streakBreakAckedRunEnd: row.streakBreakAckedRunEnd,
    );
  }
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return DriftSettingsRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(clockProvider),
  );
}

@Riverpod(keepAlive: true)
Stream<UserSettings> userSettings(Ref ref) {
  return ref.watch(settingsRepositoryProvider).watch();
}
