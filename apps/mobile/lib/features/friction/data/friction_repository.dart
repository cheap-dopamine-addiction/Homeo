import 'package:drift/drift.dart';
import 'package:homeo/core/local_db/app_database.dart';
import 'package:homeo/core/local_db/database_provider.dart';
import 'package:homeo/core/security/field_cipher.dart';
import 'package:homeo/core/time/clock.dart';
import 'package:homeo/features/friction/domain/blocked_app.dart';
import 'package:homeo/features/friction/domain/distraction_event.dart';
import 'package:homeo/features/friction/domain/emergency.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friction_repository.g.dart';

/// Local-first storage for the friction slice (watch list, distraction log,
/// emergency log). Sync to the backend pushes rows with a null `synced_at`.
abstract interface class FrictionRepository {
  Stream<List<BlockedApp>> watchBlockedApps();
  Future<BlockedApp?> findBlockedApp(String appPackageId);
  Future<void> setBlockedApp(BlockedApp app);
  Future<void> removeBlockedApp(String appPackageId);

  /// Append a resolved gate to the log (PRD §9.3).
  Future<void> logEvent(DistractionEvent event);

  /// Resolved gates for [appPackageId] at or after [since].
  Future<int> countAttemptsSince(String appPackageId, DateTime since);

  Future<void> recordEmergency(EmergencyOverride override);
  Future<EmergencyOverride?> latestEmergency();

  /// Emergency unblocks used in `[from, to)`.
  Future<int> countEmergencies(DateTime from, DateTime to);
  Stream<int> watchEmergencyCount(DateTime from, DateTime to);
}

class DriftFrictionRepository implements FrictionRepository {
  DriftFrictionRepository(this._db, this._clock, this._cipher);

  final AppDatabase _db;
  final Clock _clock;
  final FieldCipher _cipher;

  // ── Watch list ───────────────────────────────────────────────────────────

  @override
  Stream<List<BlockedApp>> watchBlockedApps() {
    final query = _db.select(_db.blockedApps)
      ..orderBy([(r) => OrderingTerm.asc(r.createdAt)]);
    return query.watch().map((rows) => rows.map(_toBlockedApp).toList());
  }

  @override
  Future<BlockedApp?> findBlockedApp(String appPackageId) async {
    final row = await (_db.select(
      _db.blockedApps,
    )..where((r) => r.appPackageId.equals(appPackageId))).getSingleOrNull();
    return row == null ? null : _toBlockedApp(row);
  }

  @override
  Future<void> setBlockedApp(BlockedApp app) async {
    final now = _clock.now();
    final existing = await (_db.select(
      _db.blockedApps,
    )..where((r) => r.appPackageId.equals(app.appPackageId))).getSingleOrNull();
    await _db
        .into(_db.blockedApps)
        .insertOnConflictUpdate(
          BlockedAppRow(
            appPackageId: app.appPackageId,
            frictionLevel: app.level.code,
            createdAt: existing?.createdAt ?? now,
            updatedAt: now,
            syncedAt: null,
          ).toCompanion(false),
        );
  }

  @override
  Future<void> removeBlockedApp(String appPackageId) async {
    await (_db.delete(
      _db.blockedApps,
    )..where((r) => r.appPackageId.equals(appPackageId))).go();
  }

  // ── Distraction log ──────────────────────────────────────────────────────

  @override
  Future<void> logEvent(DistractionEvent event) async {
    final reason = event.reasonText;
    await _db
        .into(_db.distractionEvents)
        .insert(
          DistractionEventRow(
            id: event.id,
            appPackageId: event.appPackageId,
            frictionLevel: event.level.code,
            resolvedAction: event.action.name,
            duringSession: event.duringSession,
            reasonText: reason == null ? null : await _cipher.encrypt(reason),
            occurredAt: event.occurredAt,
            syncedAt: null,
          ),
        );
  }

  @override
  Future<int> countAttemptsSince(String appPackageId, DateTime since) async {
    final t = _db.distractionEvents;
    final count = t.id.count();
    final query = _db.selectOnly(t)
      ..addColumns([count])
      ..where(
        t.appPackageId.equals(appPackageId) &
            t.occurredAt.isBiggerOrEqualValue(since),
      );
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  // ── Emergency ────────────────────────────────────────────────────────────

  @override
  Future<void> recordEmergency(EmergencyOverride override) async {
    await _db
        .into(_db.emergencyOverrides)
        .insert(
          EmergencyOverrideRow(
            id: override.id,
            occurredAt: override.occurredAt,
            windowEndsAt: override.windowEndsAt,
            partnerNotifiedAt: null,
            syncedAt: null,
          ),
        );
  }

  @override
  Future<EmergencyOverride?> latestEmergency() async {
    final row =
        await (_db.select(_db.emergencyOverrides)
              ..orderBy([(r) => OrderingTerm.desc(r.occurredAt)])
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    return EmergencyOverride(
      id: row.id,
      occurredAt: row.occurredAt,
      windowEndsAt: row.windowEndsAt,
    );
  }

  Selectable<int> _emergencyCount(DateTime from, DateTime to) {
    final t = _db.emergencyOverrides;
    final count = t.id.count();
    final query = _db.selectOnly(t)
      ..addColumns([count])
      ..where(
        t.occurredAt.isBiggerOrEqualValue(from) &
            t.occurredAt.isSmallerThanValue(to),
      );
    return query.map((row) => row.read(count) ?? 0);
  }

  @override
  Future<int> countEmergencies(DateTime from, DateTime to) =>
      _emergencyCount(from, to).getSingle();

  @override
  Stream<int> watchEmergencyCount(DateTime from, DateTime to) =>
      _emergencyCount(from, to).watchSingle();

  BlockedApp _toBlockedApp(BlockedAppRow row) => BlockedApp(
    appPackageId: row.appPackageId,
    level: FrictionLevel.fromCode(row.frictionLevel),
  );
}

@Riverpod(keepAlive: true)
FrictionRepository frictionRepository(Ref ref) {
  return DriftFrictionRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(clockProvider),
    ref.watch(fieldCipherProvider),
  );
}
