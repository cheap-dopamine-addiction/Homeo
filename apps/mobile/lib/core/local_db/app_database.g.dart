// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intentionMeta = const VerificationMeta(
    'intention',
  );
  @override
  late final GeneratedColumn<String> intention = GeneratedColumn<String>(
    'intention',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _plannedDurationSecMeta =
      const VerificationMeta('plannedDurationSec');
  @override
  late final GeneratedColumn<int> plannedDurationSec = GeneratedColumn<int>(
    'planned_duration_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualDurationSecMeta = const VerificationMeta(
    'actualDurationSec',
  );
  @override
  late final GeneratedColumn<int> actualDurationSec = GeneratedColumn<int>(
    'actual_duration_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pauseCountMeta = const VerificationMeta(
    'pauseCount',
  );
  @override
  late final GeneratedColumn<int> pauseCount = GeneratedColumn<int>(
    'pause_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pausedTotalSecMeta = const VerificationMeta(
    'pausedTotalSec',
  );
  @override
  late final GeneratedColumn<int> pausedTotalSec = GeneratedColumn<int>(
    'paused_total_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pausedAtMeta = const VerificationMeta(
    'pausedAt',
  );
  @override
  late final GeneratedColumn<DateTime> pausedAt = GeneratedColumn<DateTime>(
    'paused_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    intention,
    plannedDurationSec,
    actualDurationSec,
    status,
    startedAt,
    endedAt,
    pauseCount,
    pausedTotalSec,
    pausedAt,
    syncedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('intention')) {
      context.handle(
        _intentionMeta,
        intention.isAcceptableOrUnknown(data['intention']!, _intentionMeta),
      );
    }
    if (data.containsKey('planned_duration_sec')) {
      context.handle(
        _plannedDurationSecMeta,
        plannedDurationSec.isAcceptableOrUnknown(
          data['planned_duration_sec']!,
          _plannedDurationSecMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedDurationSecMeta);
    }
    if (data.containsKey('actual_duration_sec')) {
      context.handle(
        _actualDurationSecMeta,
        actualDurationSec.isAcceptableOrUnknown(
          data['actual_duration_sec']!,
          _actualDurationSecMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('pause_count')) {
      context.handle(
        _pauseCountMeta,
        pauseCount.isAcceptableOrUnknown(data['pause_count']!, _pauseCountMeta),
      );
    }
    if (data.containsKey('paused_total_sec')) {
      context.handle(
        _pausedTotalSecMeta,
        pausedTotalSec.isAcceptableOrUnknown(
          data['paused_total_sec']!,
          _pausedTotalSecMeta,
        ),
      );
    }
    if (data.containsKey('paused_at')) {
      context.handle(
        _pausedAtMeta,
        pausedAt.isAcceptableOrUnknown(data['paused_at']!, _pausedAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      intention: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}intention'],
      )!,
      plannedDurationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_duration_sec'],
      )!,
      actualDurationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_duration_sec'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      pauseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pause_count'],
      )!,
      pausedTotalSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paused_total_sec'],
      )!,
      pausedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paused_at'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }
}

class FocusSessionRow extends DataClass implements Insertable<FocusSessionRow> {
  final String id;
  final String intention;
  final int plannedDurationSec;
  final int actualDurationSec;
  final String status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int pauseCount;
  final int pausedTotalSec;
  final DateTime? pausedAt;

  /// Delta-sync bookkeeping (PRD §22): null `syncedAt` = dirty.
  final DateTime? syncedAt;
  final DateTime updatedAt;
  const FocusSessionRow({
    required this.id,
    required this.intention,
    required this.plannedDurationSec,
    required this.actualDurationSec,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.pauseCount,
    required this.pausedTotalSec,
    this.pausedAt,
    this.syncedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['intention'] = Variable<String>(intention);
    map['planned_duration_sec'] = Variable<int>(plannedDurationSec);
    map['actual_duration_sec'] = Variable<int>(actualDurationSec);
    map['status'] = Variable<String>(status);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['pause_count'] = Variable<int>(pauseCount);
    map['paused_total_sec'] = Variable<int>(pausedTotalSec);
    if (!nullToAbsent || pausedAt != null) {
      map['paused_at'] = Variable<DateTime>(pausedAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      intention: Value(intention),
      plannedDurationSec: Value(plannedDurationSec),
      actualDurationSec: Value(actualDurationSec),
      status: Value(status),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      pauseCount: Value(pauseCount),
      pausedTotalSec: Value(pausedTotalSec),
      pausedAt: pausedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pausedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FocusSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSessionRow(
      id: serializer.fromJson<String>(json['id']),
      intention: serializer.fromJson<String>(json['intention']),
      plannedDurationSec: serializer.fromJson<int>(json['plannedDurationSec']),
      actualDurationSec: serializer.fromJson<int>(json['actualDurationSec']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      pauseCount: serializer.fromJson<int>(json['pauseCount']),
      pausedTotalSec: serializer.fromJson<int>(json['pausedTotalSec']),
      pausedAt: serializer.fromJson<DateTime?>(json['pausedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'intention': serializer.toJson<String>(intention),
      'plannedDurationSec': serializer.toJson<int>(plannedDurationSec),
      'actualDurationSec': serializer.toJson<int>(actualDurationSec),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'pauseCount': serializer.toJson<int>(pauseCount),
      'pausedTotalSec': serializer.toJson<int>(pausedTotalSec),
      'pausedAt': serializer.toJson<DateTime?>(pausedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FocusSessionRow copyWith({
    String? id,
    String? intention,
    int? plannedDurationSec,
    int? actualDurationSec,
    String? status,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? pauseCount,
    int? pausedTotalSec,
    Value<DateTime?> pausedAt = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => FocusSessionRow(
    id: id ?? this.id,
    intention: intention ?? this.intention,
    plannedDurationSec: plannedDurationSec ?? this.plannedDurationSec,
    actualDurationSec: actualDurationSec ?? this.actualDurationSec,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    pauseCount: pauseCount ?? this.pauseCount,
    pausedTotalSec: pausedTotalSec ?? this.pausedTotalSec,
    pausedAt: pausedAt.present ? pausedAt.value : this.pausedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FocusSessionRow copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSessionRow(
      id: data.id.present ? data.id.value : this.id,
      intention: data.intention.present ? data.intention.value : this.intention,
      plannedDurationSec: data.plannedDurationSec.present
          ? data.plannedDurationSec.value
          : this.plannedDurationSec,
      actualDurationSec: data.actualDurationSec.present
          ? data.actualDurationSec.value
          : this.actualDurationSec,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      pauseCount: data.pauseCount.present
          ? data.pauseCount.value
          : this.pauseCount,
      pausedTotalSec: data.pausedTotalSec.present
          ? data.pausedTotalSec.value
          : this.pausedTotalSec,
      pausedAt: data.pausedAt.present ? data.pausedAt.value : this.pausedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionRow(')
          ..write('id: $id, ')
          ..write('intention: $intention, ')
          ..write('plannedDurationSec: $plannedDurationSec, ')
          ..write('actualDurationSec: $actualDurationSec, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('pauseCount: $pauseCount, ')
          ..write('pausedTotalSec: $pausedTotalSec, ')
          ..write('pausedAt: $pausedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    intention,
    plannedDurationSec,
    actualDurationSec,
    status,
    startedAt,
    endedAt,
    pauseCount,
    pausedTotalSec,
    pausedAt,
    syncedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSessionRow &&
          other.id == this.id &&
          other.intention == this.intention &&
          other.plannedDurationSec == this.plannedDurationSec &&
          other.actualDurationSec == this.actualDurationSec &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.pauseCount == this.pauseCount &&
          other.pausedTotalSec == this.pausedTotalSec &&
          other.pausedAt == this.pausedAt &&
          other.syncedAt == this.syncedAt &&
          other.updatedAt == this.updatedAt);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSessionRow> {
  final Value<String> id;
  final Value<String> intention;
  final Value<int> plannedDurationSec;
  final Value<int> actualDurationSec;
  final Value<String> status;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> pauseCount;
  final Value<int> pausedTotalSec;
  final Value<DateTime?> pausedAt;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.intention = const Value.absent(),
    this.plannedDurationSec = const Value.absent(),
    this.actualDurationSec = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.pauseCount = const Value.absent(),
    this.pausedTotalSec = const Value.absent(),
    this.pausedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    required String id,
    this.intention = const Value.absent(),
    required int plannedDurationSec,
    this.actualDurationSec = const Value.absent(),
    required String status,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.pauseCount = const Value.absent(),
    this.pausedTotalSec = const Value.absent(),
    this.pausedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       plannedDurationSec = Value(plannedDurationSec),
       status = Value(status),
       startedAt = Value(startedAt),
       updatedAt = Value(updatedAt);
  static Insertable<FocusSessionRow> custom({
    Expression<String>? id,
    Expression<String>? intention,
    Expression<int>? plannedDurationSec,
    Expression<int>? actualDurationSec,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? pauseCount,
    Expression<int>? pausedTotalSec,
    Expression<DateTime>? pausedAt,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (intention != null) 'intention': intention,
      if (plannedDurationSec != null)
        'planned_duration_sec': plannedDurationSec,
      if (actualDurationSec != null) 'actual_duration_sec': actualDurationSec,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (pauseCount != null) 'pause_count': pauseCount,
      if (pausedTotalSec != null) 'paused_total_sec': pausedTotalSec,
      if (pausedAt != null) 'paused_at': pausedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? intention,
    Value<int>? plannedDurationSec,
    Value<int>? actualDurationSec,
    Value<String>? status,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? pauseCount,
    Value<int>? pausedTotalSec,
    Value<DateTime?>? pausedAt,
    Value<DateTime?>? syncedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      intention: intention ?? this.intention,
      plannedDurationSec: plannedDurationSec ?? this.plannedDurationSec,
      actualDurationSec: actualDurationSec ?? this.actualDurationSec,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      pauseCount: pauseCount ?? this.pauseCount,
      pausedTotalSec: pausedTotalSec ?? this.pausedTotalSec,
      pausedAt: pausedAt ?? this.pausedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (intention.present) {
      map['intention'] = Variable<String>(intention.value);
    }
    if (plannedDurationSec.present) {
      map['planned_duration_sec'] = Variable<int>(plannedDurationSec.value);
    }
    if (actualDurationSec.present) {
      map['actual_duration_sec'] = Variable<int>(actualDurationSec.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (pauseCount.present) {
      map['pause_count'] = Variable<int>(pauseCount.value);
    }
    if (pausedTotalSec.present) {
      map['paused_total_sec'] = Variable<int>(pausedTotalSec.value);
    }
    if (pausedAt.present) {
      map['paused_at'] = Variable<DateTime>(pausedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('intention: $intention, ')
          ..write('plannedDurationSec: $plannedDurationSec, ')
          ..write('actualDurationSec: $actualDurationSec, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('pauseCount: $pauseCount, ')
          ..write('pausedTotalSec: $pausedTotalSec, ')
          ..write('pausedAt: $pausedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReflectionEntriesTable extends ReflectionEntries
    with TableInfo<$ReflectionEntriesTable, ReflectionEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReflectionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES focus_sessions (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _promptKeyMeta = const VerificationMeta(
    'promptKey',
  );
  @override
  late final GeneratedColumn<String> promptKey = GeneratedColumn<String>(
    'prompt_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodTagMeta = const VerificationMeta(
    'moodTag',
  );
  @override
  late final GeneratedColumn<String> moodTag = GeneratedColumn<String>(
    'mood_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _responseTextMeta = const VerificationMeta(
    'responseText',
  );
  @override
  late final GeneratedColumn<String> responseText = GeneratedColumn<String>(
    'response_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    promptKey,
    moodTag,
    responseText,
    createdAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reflection_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReflectionEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('prompt_key')) {
      context.handle(
        _promptKeyMeta,
        promptKey.isAcceptableOrUnknown(data['prompt_key']!, _promptKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_promptKeyMeta);
    }
    if (data.containsKey('mood_tag')) {
      context.handle(
        _moodTagMeta,
        moodTag.isAcceptableOrUnknown(data['mood_tag']!, _moodTagMeta),
      );
    }
    if (data.containsKey('response_text')) {
      context.handle(
        _responseTextMeta,
        responseText.isAcceptableOrUnknown(
          data['response_text']!,
          _responseTextMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReflectionEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReflectionEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      ),
      promptKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt_key'],
      )!,
      moodTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood_tag'],
      ),
      responseText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response_text'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $ReflectionEntriesTable createAlias(String alias) {
    return $ReflectionEntriesTable(attachedDatabase, alias);
  }
}

class ReflectionEntryRow extends DataClass
    implements Insertable<ReflectionEntryRow> {
  final String id;
  final String? sessionId;
  final String promptKey;
  final String? moodTag;
  final String? responseText;
  final DateTime createdAt;
  final DateTime? syncedAt;
  const ReflectionEntryRow({
    required this.id,
    this.sessionId,
    required this.promptKey,
    this.moodTag,
    this.responseText,
    required this.createdAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['prompt_key'] = Variable<String>(promptKey);
    if (!nullToAbsent || moodTag != null) {
      map['mood_tag'] = Variable<String>(moodTag);
    }
    if (!nullToAbsent || responseText != null) {
      map['response_text'] = Variable<String>(responseText);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  ReflectionEntriesCompanion toCompanion(bool nullToAbsent) {
    return ReflectionEntriesCompanion(
      id: Value(id),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      promptKey: Value(promptKey),
      moodTag: moodTag == null && nullToAbsent
          ? const Value.absent()
          : Value(moodTag),
      responseText: responseText == null && nullToAbsent
          ? const Value.absent()
          : Value(responseText),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory ReflectionEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReflectionEntryRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      promptKey: serializer.fromJson<String>(json['promptKey']),
      moodTag: serializer.fromJson<String?>(json['moodTag']),
      responseText: serializer.fromJson<String?>(json['responseText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String?>(sessionId),
      'promptKey': serializer.toJson<String>(promptKey),
      'moodTag': serializer.toJson<String?>(moodTag),
      'responseText': serializer.toJson<String?>(responseText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  ReflectionEntryRow copyWith({
    String? id,
    Value<String?> sessionId = const Value.absent(),
    String? promptKey,
    Value<String?> moodTag = const Value.absent(),
    Value<String?> responseText = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => ReflectionEntryRow(
    id: id ?? this.id,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    promptKey: promptKey ?? this.promptKey,
    moodTag: moodTag.present ? moodTag.value : this.moodTag,
    responseText: responseText.present ? responseText.value : this.responseText,
    createdAt: createdAt ?? this.createdAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  ReflectionEntryRow copyWithCompanion(ReflectionEntriesCompanion data) {
    return ReflectionEntryRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      promptKey: data.promptKey.present ? data.promptKey.value : this.promptKey,
      moodTag: data.moodTag.present ? data.moodTag.value : this.moodTag,
      responseText: data.responseText.present
          ? data.responseText.value
          : this.responseText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReflectionEntryRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('promptKey: $promptKey, ')
          ..write('moodTag: $moodTag, ')
          ..write('responseText: $responseText, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    promptKey,
    moodTag,
    responseText,
    createdAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReflectionEntryRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.promptKey == this.promptKey &&
          other.moodTag == this.moodTag &&
          other.responseText == this.responseText &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class ReflectionEntriesCompanion extends UpdateCompanion<ReflectionEntryRow> {
  final Value<String> id;
  final Value<String?> sessionId;
  final Value<String> promptKey;
  final Value<String?> moodTag;
  final Value<String?> responseText;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const ReflectionEntriesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.promptKey = const Value.absent(),
    this.moodTag = const Value.absent(),
    this.responseText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReflectionEntriesCompanion.insert({
    required String id,
    this.sessionId = const Value.absent(),
    required String promptKey,
    this.moodTag = const Value.absent(),
    this.responseText = const Value.absent(),
    required DateTime createdAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       promptKey = Value(promptKey),
       createdAt = Value(createdAt);
  static Insertable<ReflectionEntryRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? promptKey,
    Expression<String>? moodTag,
    Expression<String>? responseText,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (promptKey != null) 'prompt_key': promptKey,
      if (moodTag != null) 'mood_tag': moodTag,
      if (responseText != null) 'response_text': responseText,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReflectionEntriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? sessionId,
    Value<String>? promptKey,
    Value<String?>? moodTag,
    Value<String?>? responseText,
    Value<DateTime>? createdAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return ReflectionEntriesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      promptKey: promptKey ?? this.promptKey,
      moodTag: moodTag ?? this.moodTag,
      responseText: responseText ?? this.responseText,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (promptKey.present) {
      map['prompt_key'] = Variable<String>(promptKey.value);
    }
    if (moodTag.present) {
      map['mood_tag'] = Variable<String>(moodTag.value);
    }
    if (responseText.present) {
      map['response_text'] = Variable<String>(responseText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReflectionEntriesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('promptKey: $promptKey, ')
          ..write('moodTag: $moodTag, ')
          ..write('responseText: $responseText, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BlockedAppsTable extends BlockedApps
    with TableInfo<$BlockedAppsTable, BlockedAppRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockedAppsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _appPackageIdMeta = const VerificationMeta(
    'appPackageId',
  );
  @override
  late final GeneratedColumn<String> appPackageId = GeneratedColumn<String>(
    'app_package_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frictionLevelMeta = const VerificationMeta(
    'frictionLevel',
  );
  @override
  late final GeneratedColumn<int> frictionLevel = GeneratedColumn<int>(
    'friction_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    appPackageId,
    frictionLevel,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blocked_apps';
  @override
  VerificationContext validateIntegrity(
    Insertable<BlockedAppRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('app_package_id')) {
      context.handle(
        _appPackageIdMeta,
        appPackageId.isAcceptableOrUnknown(
          data['app_package_id']!,
          _appPackageIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appPackageIdMeta);
    }
    if (data.containsKey('friction_level')) {
      context.handle(
        _frictionLevelMeta,
        frictionLevel.isAcceptableOrUnknown(
          data['friction_level']!,
          _frictionLevelMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {appPackageId};
  @override
  BlockedAppRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockedAppRow(
      appPackageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_package_id'],
      )!,
      frictionLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}friction_level'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $BlockedAppsTable createAlias(String alias) {
    return $BlockedAppsTable(attachedDatabase, alias);
  }
}

class BlockedAppRow extends DataClass implements Insertable<BlockedAppRow> {
  final String appPackageId;
  final int frictionLevel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const BlockedAppRow({
    required this.appPackageId,
    required this.frictionLevel,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['app_package_id'] = Variable<String>(appPackageId);
    map['friction_level'] = Variable<int>(frictionLevel);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  BlockedAppsCompanion toCompanion(bool nullToAbsent) {
    return BlockedAppsCompanion(
      appPackageId: Value(appPackageId),
      frictionLevel: Value(frictionLevel),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory BlockedAppRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockedAppRow(
      appPackageId: serializer.fromJson<String>(json['appPackageId']),
      frictionLevel: serializer.fromJson<int>(json['frictionLevel']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'appPackageId': serializer.toJson<String>(appPackageId),
      'frictionLevel': serializer.toJson<int>(frictionLevel),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  BlockedAppRow copyWith({
    String? appPackageId,
    int? frictionLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => BlockedAppRow(
    appPackageId: appPackageId ?? this.appPackageId,
    frictionLevel: frictionLevel ?? this.frictionLevel,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  BlockedAppRow copyWithCompanion(BlockedAppsCompanion data) {
    return BlockedAppRow(
      appPackageId: data.appPackageId.present
          ? data.appPackageId.value
          : this.appPackageId,
      frictionLevel: data.frictionLevel.present
          ? data.frictionLevel.value
          : this.frictionLevel,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockedAppRow(')
          ..write('appPackageId: $appPackageId, ')
          ..write('frictionLevel: $frictionLevel, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(appPackageId, frictionLevel, createdAt, updatedAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockedAppRow &&
          other.appPackageId == this.appPackageId &&
          other.frictionLevel == this.frictionLevel &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class BlockedAppsCompanion extends UpdateCompanion<BlockedAppRow> {
  final Value<String> appPackageId;
  final Value<int> frictionLevel;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const BlockedAppsCompanion({
    this.appPackageId = const Value.absent(),
    this.frictionLevel = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BlockedAppsCompanion.insert({
    required String appPackageId,
    this.frictionLevel = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : appPackageId = Value(appPackageId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BlockedAppRow> custom({
    Expression<String>? appPackageId,
    Expression<int>? frictionLevel,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (appPackageId != null) 'app_package_id': appPackageId,
      if (frictionLevel != null) 'friction_level': frictionLevel,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BlockedAppsCompanion copyWith({
    Value<String>? appPackageId,
    Value<int>? frictionLevel,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return BlockedAppsCompanion(
      appPackageId: appPackageId ?? this.appPackageId,
      frictionLevel: frictionLevel ?? this.frictionLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (appPackageId.present) {
      map['app_package_id'] = Variable<String>(appPackageId.value);
    }
    if (frictionLevel.present) {
      map['friction_level'] = Variable<int>(frictionLevel.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockedAppsCompanion(')
          ..write('appPackageId: $appPackageId, ')
          ..write('frictionLevel: $frictionLevel, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DistractionEventsTable extends DistractionEvents
    with TableInfo<$DistractionEventsTable, DistractionEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DistractionEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appPackageIdMeta = const VerificationMeta(
    'appPackageId',
  );
  @override
  late final GeneratedColumn<String> appPackageId = GeneratedColumn<String>(
    'app_package_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frictionLevelMeta = const VerificationMeta(
    'frictionLevel',
  );
  @override
  late final GeneratedColumn<int> frictionLevel = GeneratedColumn<int>(
    'friction_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedActionMeta = const VerificationMeta(
    'resolvedAction',
  );
  @override
  late final GeneratedColumn<String> resolvedAction = GeneratedColumn<String>(
    'resolved_action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _duringSessionMeta = const VerificationMeta(
    'duringSession',
  );
  @override
  late final GeneratedColumn<bool> duringSession = GeneratedColumn<bool>(
    'during_session',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("during_session" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reasonTextMeta = const VerificationMeta(
    'reasonText',
  );
  @override
  late final GeneratedColumn<String> reasonText = GeneratedColumn<String>(
    'reason_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    appPackageId,
    frictionLevel,
    resolvedAction,
    duringSession,
    reasonText,
    occurredAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'distraction_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<DistractionEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('app_package_id')) {
      context.handle(
        _appPackageIdMeta,
        appPackageId.isAcceptableOrUnknown(
          data['app_package_id']!,
          _appPackageIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appPackageIdMeta);
    }
    if (data.containsKey('friction_level')) {
      context.handle(
        _frictionLevelMeta,
        frictionLevel.isAcceptableOrUnknown(
          data['friction_level']!,
          _frictionLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frictionLevelMeta);
    }
    if (data.containsKey('resolved_action')) {
      context.handle(
        _resolvedActionMeta,
        resolvedAction.isAcceptableOrUnknown(
          data['resolved_action']!,
          _resolvedActionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resolvedActionMeta);
    }
    if (data.containsKey('during_session')) {
      context.handle(
        _duringSessionMeta,
        duringSession.isAcceptableOrUnknown(
          data['during_session']!,
          _duringSessionMeta,
        ),
      );
    }
    if (data.containsKey('reason_text')) {
      context.handle(
        _reasonTextMeta,
        reasonText.isAcceptableOrUnknown(data['reason_text']!, _reasonTextMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DistractionEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DistractionEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      appPackageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_package_id'],
      )!,
      frictionLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}friction_level'],
      )!,
      resolvedAction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resolved_action'],
      )!,
      duringSession: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}during_session'],
      )!,
      reasonText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_text'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $DistractionEventsTable createAlias(String alias) {
    return $DistractionEventsTable(attachedDatabase, alias);
  }
}

class DistractionEventRow extends DataClass
    implements Insertable<DistractionEventRow> {
  final String id;
  final String appPackageId;
  final int frictionLevel;
  final String resolvedAction;
  final bool duringSession;
  final String? reasonText;
  final DateTime occurredAt;
  final DateTime? syncedAt;
  const DistractionEventRow({
    required this.id,
    required this.appPackageId,
    required this.frictionLevel,
    required this.resolvedAction,
    required this.duringSession,
    this.reasonText,
    required this.occurredAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['app_package_id'] = Variable<String>(appPackageId);
    map['friction_level'] = Variable<int>(frictionLevel);
    map['resolved_action'] = Variable<String>(resolvedAction);
    map['during_session'] = Variable<bool>(duringSession);
    if (!nullToAbsent || reasonText != null) {
      map['reason_text'] = Variable<String>(reasonText);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  DistractionEventsCompanion toCompanion(bool nullToAbsent) {
    return DistractionEventsCompanion(
      id: Value(id),
      appPackageId: Value(appPackageId),
      frictionLevel: Value(frictionLevel),
      resolvedAction: Value(resolvedAction),
      duringSession: Value(duringSession),
      reasonText: reasonText == null && nullToAbsent
          ? const Value.absent()
          : Value(reasonText),
      occurredAt: Value(occurredAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory DistractionEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DistractionEventRow(
      id: serializer.fromJson<String>(json['id']),
      appPackageId: serializer.fromJson<String>(json['appPackageId']),
      frictionLevel: serializer.fromJson<int>(json['frictionLevel']),
      resolvedAction: serializer.fromJson<String>(json['resolvedAction']),
      duringSession: serializer.fromJson<bool>(json['duringSession']),
      reasonText: serializer.fromJson<String?>(json['reasonText']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'appPackageId': serializer.toJson<String>(appPackageId),
      'frictionLevel': serializer.toJson<int>(frictionLevel),
      'resolvedAction': serializer.toJson<String>(resolvedAction),
      'duringSession': serializer.toJson<bool>(duringSession),
      'reasonText': serializer.toJson<String?>(reasonText),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  DistractionEventRow copyWith({
    String? id,
    String? appPackageId,
    int? frictionLevel,
    String? resolvedAction,
    bool? duringSession,
    Value<String?> reasonText = const Value.absent(),
    DateTime? occurredAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => DistractionEventRow(
    id: id ?? this.id,
    appPackageId: appPackageId ?? this.appPackageId,
    frictionLevel: frictionLevel ?? this.frictionLevel,
    resolvedAction: resolvedAction ?? this.resolvedAction,
    duringSession: duringSession ?? this.duringSession,
    reasonText: reasonText.present ? reasonText.value : this.reasonText,
    occurredAt: occurredAt ?? this.occurredAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  DistractionEventRow copyWithCompanion(DistractionEventsCompanion data) {
    return DistractionEventRow(
      id: data.id.present ? data.id.value : this.id,
      appPackageId: data.appPackageId.present
          ? data.appPackageId.value
          : this.appPackageId,
      frictionLevel: data.frictionLevel.present
          ? data.frictionLevel.value
          : this.frictionLevel,
      resolvedAction: data.resolvedAction.present
          ? data.resolvedAction.value
          : this.resolvedAction,
      duringSession: data.duringSession.present
          ? data.duringSession.value
          : this.duringSession,
      reasonText: data.reasonText.present
          ? data.reasonText.value
          : this.reasonText,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DistractionEventRow(')
          ..write('id: $id, ')
          ..write('appPackageId: $appPackageId, ')
          ..write('frictionLevel: $frictionLevel, ')
          ..write('resolvedAction: $resolvedAction, ')
          ..write('duringSession: $duringSession, ')
          ..write('reasonText: $reasonText, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    appPackageId,
    frictionLevel,
    resolvedAction,
    duringSession,
    reasonText,
    occurredAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DistractionEventRow &&
          other.id == this.id &&
          other.appPackageId == this.appPackageId &&
          other.frictionLevel == this.frictionLevel &&
          other.resolvedAction == this.resolvedAction &&
          other.duringSession == this.duringSession &&
          other.reasonText == this.reasonText &&
          other.occurredAt == this.occurredAt &&
          other.syncedAt == this.syncedAt);
}

class DistractionEventsCompanion extends UpdateCompanion<DistractionEventRow> {
  final Value<String> id;
  final Value<String> appPackageId;
  final Value<int> frictionLevel;
  final Value<String> resolvedAction;
  final Value<bool> duringSession;
  final Value<String?> reasonText;
  final Value<DateTime> occurredAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const DistractionEventsCompanion({
    this.id = const Value.absent(),
    this.appPackageId = const Value.absent(),
    this.frictionLevel = const Value.absent(),
    this.resolvedAction = const Value.absent(),
    this.duringSession = const Value.absent(),
    this.reasonText = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DistractionEventsCompanion.insert({
    required String id,
    required String appPackageId,
    required int frictionLevel,
    required String resolvedAction,
    this.duringSession = const Value.absent(),
    this.reasonText = const Value.absent(),
    required DateTime occurredAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       appPackageId = Value(appPackageId),
       frictionLevel = Value(frictionLevel),
       resolvedAction = Value(resolvedAction),
       occurredAt = Value(occurredAt);
  static Insertable<DistractionEventRow> custom({
    Expression<String>? id,
    Expression<String>? appPackageId,
    Expression<int>? frictionLevel,
    Expression<String>? resolvedAction,
    Expression<bool>? duringSession,
    Expression<String>? reasonText,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appPackageId != null) 'app_package_id': appPackageId,
      if (frictionLevel != null) 'friction_level': frictionLevel,
      if (resolvedAction != null) 'resolved_action': resolvedAction,
      if (duringSession != null) 'during_session': duringSession,
      if (reasonText != null) 'reason_text': reasonText,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DistractionEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? appPackageId,
    Value<int>? frictionLevel,
    Value<String>? resolvedAction,
    Value<bool>? duringSession,
    Value<String?>? reasonText,
    Value<DateTime>? occurredAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return DistractionEventsCompanion(
      id: id ?? this.id,
      appPackageId: appPackageId ?? this.appPackageId,
      frictionLevel: frictionLevel ?? this.frictionLevel,
      resolvedAction: resolvedAction ?? this.resolvedAction,
      duringSession: duringSession ?? this.duringSession,
      reasonText: reasonText ?? this.reasonText,
      occurredAt: occurredAt ?? this.occurredAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (appPackageId.present) {
      map['app_package_id'] = Variable<String>(appPackageId.value);
    }
    if (frictionLevel.present) {
      map['friction_level'] = Variable<int>(frictionLevel.value);
    }
    if (resolvedAction.present) {
      map['resolved_action'] = Variable<String>(resolvedAction.value);
    }
    if (duringSession.present) {
      map['during_session'] = Variable<bool>(duringSession.value);
    }
    if (reasonText.present) {
      map['reason_text'] = Variable<String>(reasonText.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DistractionEventsCompanion(')
          ..write('id: $id, ')
          ..write('appPackageId: $appPackageId, ')
          ..write('frictionLevel: $frictionLevel, ')
          ..write('resolvedAction: $resolvedAction, ')
          ..write('duringSession: $duringSession, ')
          ..write('reasonText: $reasonText, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTableTable extends UserSettingsTable
    with TableInfo<$UserSettingsTableTable, UserSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('local'),
  );
  static const VerificationMeta _defaultFrictionLevelMeta =
      const VerificationMeta('defaultFrictionLevel');
  @override
  late final GeneratedColumn<int> defaultFrictionLevel = GeneratedColumn<int>(
    'default_friction_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _emergencyLimitPerMonthMeta =
      const VerificationMeta('emergencyLimitPerMonth');
  @override
  late final GeneratedColumn<int> emergencyLimitPerMonth = GeneratedColumn<int>(
    'emergency_limit_per_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _streakBreakAckedRunEndMeta =
      const VerificationMeta('streakBreakAckedRunEnd');
  @override
  late final GeneratedColumn<DateTime> streakBreakAckedRunEnd =
      GeneratedColumn<DateTime>(
        'streak_break_acked_run_end',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    defaultFrictionLevel,
    emergencyLimitPerMonth,
    streakBreakAckedRunEnd,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('default_friction_level')) {
      context.handle(
        _defaultFrictionLevelMeta,
        defaultFrictionLevel.isAcceptableOrUnknown(
          data['default_friction_level']!,
          _defaultFrictionLevelMeta,
        ),
      );
    }
    if (data.containsKey('emergency_limit_per_month')) {
      context.handle(
        _emergencyLimitPerMonthMeta,
        emergencyLimitPerMonth.isAcceptableOrUnknown(
          data['emergency_limit_per_month']!,
          _emergencyLimitPerMonthMeta,
        ),
      );
    }
    if (data.containsKey('streak_break_acked_run_end')) {
      context.handle(
        _streakBreakAckedRunEndMeta,
        streakBreakAckedRunEnd.isAcceptableOrUnknown(
          data['streak_break_acked_run_end']!,
          _streakBreakAckedRunEndMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      defaultFrictionLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_friction_level'],
      )!,
      emergencyLimitPerMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}emergency_limit_per_month'],
      )!,
      streakBreakAckedRunEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}streak_break_acked_run_end'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserSettingsTableTable createAlias(String alias) {
    return $UserSettingsTableTable(attachedDatabase, alias);
  }
}

class UserSettingsRow extends DataClass implements Insertable<UserSettingsRow> {
  final String id;
  final int defaultFrictionLevel;
  final int emergencyLimitPerMonth;

  /// End day of the streak run whose break the user already acknowledged.
  final DateTime? streakBreakAckedRunEnd;
  final DateTime updatedAt;
  const UserSettingsRow({
    required this.id,
    required this.defaultFrictionLevel,
    required this.emergencyLimitPerMonth,
    this.streakBreakAckedRunEnd,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['default_friction_level'] = Variable<int>(defaultFrictionLevel);
    map['emergency_limit_per_month'] = Variable<int>(emergencyLimitPerMonth);
    if (!nullToAbsent || streakBreakAckedRunEnd != null) {
      map['streak_break_acked_run_end'] = Variable<DateTime>(
        streakBreakAckedRunEnd,
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsTableCompanion(
      id: Value(id),
      defaultFrictionLevel: Value(defaultFrictionLevel),
      emergencyLimitPerMonth: Value(emergencyLimitPerMonth),
      streakBreakAckedRunEnd: streakBreakAckedRunEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(streakBreakAckedRunEnd),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsRow(
      id: serializer.fromJson<String>(json['id']),
      defaultFrictionLevel: serializer.fromJson<int>(
        json['defaultFrictionLevel'],
      ),
      emergencyLimitPerMonth: serializer.fromJson<int>(
        json['emergencyLimitPerMonth'],
      ),
      streakBreakAckedRunEnd: serializer.fromJson<DateTime?>(
        json['streakBreakAckedRunEnd'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'defaultFrictionLevel': serializer.toJson<int>(defaultFrictionLevel),
      'emergencyLimitPerMonth': serializer.toJson<int>(emergencyLimitPerMonth),
      'streakBreakAckedRunEnd': serializer.toJson<DateTime?>(
        streakBreakAckedRunEnd,
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserSettingsRow copyWith({
    String? id,
    int? defaultFrictionLevel,
    int? emergencyLimitPerMonth,
    Value<DateTime?> streakBreakAckedRunEnd = const Value.absent(),
    DateTime? updatedAt,
  }) => UserSettingsRow(
    id: id ?? this.id,
    defaultFrictionLevel: defaultFrictionLevel ?? this.defaultFrictionLevel,
    emergencyLimitPerMonth:
        emergencyLimitPerMonth ?? this.emergencyLimitPerMonth,
    streakBreakAckedRunEnd: streakBreakAckedRunEnd.present
        ? streakBreakAckedRunEnd.value
        : this.streakBreakAckedRunEnd,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserSettingsRow copyWithCompanion(UserSettingsTableCompanion data) {
    return UserSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      defaultFrictionLevel: data.defaultFrictionLevel.present
          ? data.defaultFrictionLevel.value
          : this.defaultFrictionLevel,
      emergencyLimitPerMonth: data.emergencyLimitPerMonth.present
          ? data.emergencyLimitPerMonth.value
          : this.emergencyLimitPerMonth,
      streakBreakAckedRunEnd: data.streakBreakAckedRunEnd.present
          ? data.streakBreakAckedRunEnd.value
          : this.streakBreakAckedRunEnd,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsRow(')
          ..write('id: $id, ')
          ..write('defaultFrictionLevel: $defaultFrictionLevel, ')
          ..write('emergencyLimitPerMonth: $emergencyLimitPerMonth, ')
          ..write('streakBreakAckedRunEnd: $streakBreakAckedRunEnd, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    defaultFrictionLevel,
    emergencyLimitPerMonth,
    streakBreakAckedRunEnd,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsRow &&
          other.id == this.id &&
          other.defaultFrictionLevel == this.defaultFrictionLevel &&
          other.emergencyLimitPerMonth == this.emergencyLimitPerMonth &&
          other.streakBreakAckedRunEnd == this.streakBreakAckedRunEnd &&
          other.updatedAt == this.updatedAt);
}

class UserSettingsTableCompanion extends UpdateCompanion<UserSettingsRow> {
  final Value<String> id;
  final Value<int> defaultFrictionLevel;
  final Value<int> emergencyLimitPerMonth;
  final Value<DateTime?> streakBreakAckedRunEnd;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserSettingsTableCompanion({
    this.id = const Value.absent(),
    this.defaultFrictionLevel = const Value.absent(),
    this.emergencyLimitPerMonth = const Value.absent(),
    this.streakBreakAckedRunEnd = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.defaultFrictionLevel = const Value.absent(),
    this.emergencyLimitPerMonth = const Value.absent(),
    this.streakBreakAckedRunEnd = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : updatedAt = Value(updatedAt);
  static Insertable<UserSettingsRow> custom({
    Expression<String>? id,
    Expression<int>? defaultFrictionLevel,
    Expression<int>? emergencyLimitPerMonth,
    Expression<DateTime>? streakBreakAckedRunEnd,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (defaultFrictionLevel != null)
        'default_friction_level': defaultFrictionLevel,
      if (emergencyLimitPerMonth != null)
        'emergency_limit_per_month': emergencyLimitPerMonth,
      if (streakBreakAckedRunEnd != null)
        'streak_break_acked_run_end': streakBreakAckedRunEnd,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsTableCompanion copyWith({
    Value<String>? id,
    Value<int>? defaultFrictionLevel,
    Value<int>? emergencyLimitPerMonth,
    Value<DateTime?>? streakBreakAckedRunEnd,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserSettingsTableCompanion(
      id: id ?? this.id,
      defaultFrictionLevel: defaultFrictionLevel ?? this.defaultFrictionLevel,
      emergencyLimitPerMonth:
          emergencyLimitPerMonth ?? this.emergencyLimitPerMonth,
      streakBreakAckedRunEnd:
          streakBreakAckedRunEnd ?? this.streakBreakAckedRunEnd,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (defaultFrictionLevel.present) {
      map['default_friction_level'] = Variable<int>(defaultFrictionLevel.value);
    }
    if (emergencyLimitPerMonth.present) {
      map['emergency_limit_per_month'] = Variable<int>(
        emergencyLimitPerMonth.value,
      );
    }
    if (streakBreakAckedRunEnd.present) {
      map['streak_break_acked_run_end'] = Variable<DateTime>(
        streakBreakAckedRunEnd.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('defaultFrictionLevel: $defaultFrictionLevel, ')
          ..write('emergencyLimitPerMonth: $emergencyLimitPerMonth, ')
          ..write('streakBreakAckedRunEnd: $streakBreakAckedRunEnd, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmergencyOverridesTable extends EmergencyOverrides
    with TableInfo<$EmergencyOverridesTable, EmergencyOverrideRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmergencyOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _windowEndsAtMeta = const VerificationMeta(
    'windowEndsAt',
  );
  @override
  late final GeneratedColumn<DateTime> windowEndsAt = GeneratedColumn<DateTime>(
    'window_ends_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partnerNotifiedAtMeta = const VerificationMeta(
    'partnerNotifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> partnerNotifiedAt =
      GeneratedColumn<DateTime>(
        'partner_notified_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    occurredAt,
    windowEndsAt,
    partnerNotifiedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emergency_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmergencyOverrideRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('window_ends_at')) {
      context.handle(
        _windowEndsAtMeta,
        windowEndsAt.isAcceptableOrUnknown(
          data['window_ends_at']!,
          _windowEndsAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_windowEndsAtMeta);
    }
    if (data.containsKey('partner_notified_at')) {
      context.handle(
        _partnerNotifiedAtMeta,
        partnerNotifiedAt.isAcceptableOrUnknown(
          data['partner_notified_at']!,
          _partnerNotifiedAtMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmergencyOverrideRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmergencyOverrideRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      windowEndsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}window_ends_at'],
      )!,
      partnerNotifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}partner_notified_at'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $EmergencyOverridesTable createAlias(String alias) {
    return $EmergencyOverridesTable(attachedDatabase, alias);
  }
}

class EmergencyOverrideRow extends DataClass
    implements Insertable<EmergencyOverrideRow> {
  final String id;
  final DateTime occurredAt;
  final DateTime windowEndsAt;
  final DateTime? partnerNotifiedAt;
  final DateTime? syncedAt;
  const EmergencyOverrideRow({
    required this.id,
    required this.occurredAt,
    required this.windowEndsAt,
    this.partnerNotifiedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['window_ends_at'] = Variable<DateTime>(windowEndsAt);
    if (!nullToAbsent || partnerNotifiedAt != null) {
      map['partner_notified_at'] = Variable<DateTime>(partnerNotifiedAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  EmergencyOverridesCompanion toCompanion(bool nullToAbsent) {
    return EmergencyOverridesCompanion(
      id: Value(id),
      occurredAt: Value(occurredAt),
      windowEndsAt: Value(windowEndsAt),
      partnerNotifiedAt: partnerNotifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(partnerNotifiedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory EmergencyOverrideRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmergencyOverrideRow(
      id: serializer.fromJson<String>(json['id']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      windowEndsAt: serializer.fromJson<DateTime>(json['windowEndsAt']),
      partnerNotifiedAt: serializer.fromJson<DateTime?>(
        json['partnerNotifiedAt'],
      ),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'windowEndsAt': serializer.toJson<DateTime>(windowEndsAt),
      'partnerNotifiedAt': serializer.toJson<DateTime?>(partnerNotifiedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  EmergencyOverrideRow copyWith({
    String? id,
    DateTime? occurredAt,
    DateTime? windowEndsAt,
    Value<DateTime?> partnerNotifiedAt = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => EmergencyOverrideRow(
    id: id ?? this.id,
    occurredAt: occurredAt ?? this.occurredAt,
    windowEndsAt: windowEndsAt ?? this.windowEndsAt,
    partnerNotifiedAt: partnerNotifiedAt.present
        ? partnerNotifiedAt.value
        : this.partnerNotifiedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  EmergencyOverrideRow copyWithCompanion(EmergencyOverridesCompanion data) {
    return EmergencyOverrideRow(
      id: data.id.present ? data.id.value : this.id,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      windowEndsAt: data.windowEndsAt.present
          ? data.windowEndsAt.value
          : this.windowEndsAt,
      partnerNotifiedAt: data.partnerNotifiedAt.present
          ? data.partnerNotifiedAt.value
          : this.partnerNotifiedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyOverrideRow(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('windowEndsAt: $windowEndsAt, ')
          ..write('partnerNotifiedAt: $partnerNotifiedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, occurredAt, windowEndsAt, partnerNotifiedAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmergencyOverrideRow &&
          other.id == this.id &&
          other.occurredAt == this.occurredAt &&
          other.windowEndsAt == this.windowEndsAt &&
          other.partnerNotifiedAt == this.partnerNotifiedAt &&
          other.syncedAt == this.syncedAt);
}

class EmergencyOverridesCompanion
    extends UpdateCompanion<EmergencyOverrideRow> {
  final Value<String> id;
  final Value<DateTime> occurredAt;
  final Value<DateTime> windowEndsAt;
  final Value<DateTime?> partnerNotifiedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const EmergencyOverridesCompanion({
    this.id = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.windowEndsAt = const Value.absent(),
    this.partnerNotifiedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmergencyOverridesCompanion.insert({
    required String id,
    required DateTime occurredAt,
    required DateTime windowEndsAt,
    this.partnerNotifiedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       occurredAt = Value(occurredAt),
       windowEndsAt = Value(windowEndsAt);
  static Insertable<EmergencyOverrideRow> custom({
    Expression<String>? id,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? windowEndsAt,
    Expression<DateTime>? partnerNotifiedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (windowEndsAt != null) 'window_ends_at': windowEndsAt,
      if (partnerNotifiedAt != null) 'partner_notified_at': partnerNotifiedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmergencyOverridesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? occurredAt,
    Value<DateTime>? windowEndsAt,
    Value<DateTime?>? partnerNotifiedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return EmergencyOverridesCompanion(
      id: id ?? this.id,
      occurredAt: occurredAt ?? this.occurredAt,
      windowEndsAt: windowEndsAt ?? this.windowEndsAt,
      partnerNotifiedAt: partnerNotifiedAt ?? this.partnerNotifiedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (windowEndsAt.present) {
      map['window_ends_at'] = Variable<DateTime>(windowEndsAt.value);
    }
    if (partnerNotifiedAt.present) {
      map['partner_notified_at'] = Variable<DateTime>(partnerNotifiedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyOverridesCompanion(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('windowEndsAt: $windowEndsAt, ')
          ..write('partnerNotifiedAt: $partnerNotifiedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $ReflectionEntriesTable reflectionEntries =
      $ReflectionEntriesTable(this);
  late final $BlockedAppsTable blockedApps = $BlockedAppsTable(this);
  late final $DistractionEventsTable distractionEvents =
      $DistractionEventsTable(this);
  late final $UserSettingsTableTable userSettingsTable =
      $UserSettingsTableTable(this);
  late final $EmergencyOverridesTable emergencyOverrides =
      $EmergencyOverridesTable(this);
  late final Index idxFocusSessionsStartedAt = Index(
    'idx_focus_sessions_started_at',
    'CREATE INDEX idx_focus_sessions_started_at ON focus_sessions (started_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    focusSessions,
    reflectionEntries,
    blockedApps,
    distractionEvents,
    userSettingsTable,
    emergencyOverrides,
    idxFocusSessionsStartedAt,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'focus_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reflection_entries', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$FocusSessionsTableCreateCompanionBuilder =
    FocusSessionsCompanion Function({
      required String id,
      Value<String> intention,
      required int plannedDurationSec,
      Value<int> actualDurationSec,
      required String status,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int> pauseCount,
      Value<int> pausedTotalSec,
      Value<DateTime?> pausedAt,
      Value<DateTime?> syncedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$FocusSessionsTableUpdateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<String> id,
      Value<String> intention,
      Value<int> plannedDurationSec,
      Value<int> actualDurationSec,
      Value<String> status,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> pauseCount,
      Value<int> pausedTotalSec,
      Value<DateTime?> pausedAt,
      Value<DateTime?> syncedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$FocusSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSessionRow> {
  $$FocusSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ReflectionEntriesTable, List<ReflectionEntryRow>>
  _reflectionEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.reflectionEntries,
        aliasName: 'focus_sessions__id__reflection_entries__session_id',
      );

  $$ReflectionEntriesTableProcessedTableManager get reflectionEntriesRefs {
    final manager = $$ReflectionEntriesTableTableManager(
      $_db,
      $_db.reflectionEntries,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reflectionEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FocusSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get intention => $composableBuilder(
    column: $table.intention,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedDurationSec => $composableBuilder(
    column: $table.plannedDurationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualDurationSec => $composableBuilder(
    column: $table.actualDurationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pauseCount => $composableBuilder(
    column: $table.pauseCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pausedTotalSec => $composableBuilder(
    column: $table.pausedTotalSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pausedAt => $composableBuilder(
    column: $table.pausedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> reflectionEntriesRefs(
    Expression<bool> Function($$ReflectionEntriesTableFilterComposer f) f,
  ) {
    final $$ReflectionEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reflectionEntries,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReflectionEntriesTableFilterComposer(
            $db: $db,
            $table: $db.reflectionEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FocusSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intention => $composableBuilder(
    column: $table.intention,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedDurationSec => $composableBuilder(
    column: $table.plannedDurationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualDurationSec => $composableBuilder(
    column: $table.actualDurationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pauseCount => $composableBuilder(
    column: $table.pauseCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pausedTotalSec => $composableBuilder(
    column: $table.pausedTotalSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pausedAt => $composableBuilder(
    column: $table.pausedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FocusSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get intention =>
      $composableBuilder(column: $table.intention, builder: (column) => column);

  GeneratedColumn<int> get plannedDurationSec => $composableBuilder(
    column: $table.plannedDurationSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualDurationSec => $composableBuilder(
    column: $table.actualDurationSec,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get pauseCount => $composableBuilder(
    column: $table.pauseCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pausedTotalSec => $composableBuilder(
    column: $table.pausedTotalSec,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get pausedAt =>
      $composableBuilder(column: $table.pausedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> reflectionEntriesRefs<T extends Object>(
    Expression<T> Function($$ReflectionEntriesTableAnnotationComposer a) f,
  ) {
    final $$ReflectionEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.reflectionEntries,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReflectionEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.reflectionEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FocusSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusSessionsTable,
          FocusSessionRow,
          $$FocusSessionsTableFilterComposer,
          $$FocusSessionsTableOrderingComposer,
          $$FocusSessionsTableAnnotationComposer,
          $$FocusSessionsTableCreateCompanionBuilder,
          $$FocusSessionsTableUpdateCompanionBuilder,
          (FocusSessionRow, $$FocusSessionsTableReferences),
          FocusSessionRow,
          PrefetchHooks Function({bool reflectionEntriesRefs})
        > {
  $$FocusSessionsTableTableManager(_$AppDatabase db, $FocusSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> intention = const Value.absent(),
                Value<int> plannedDurationSec = const Value.absent(),
                Value<int> actualDurationSec = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> pauseCount = const Value.absent(),
                Value<int> pausedTotalSec = const Value.absent(),
                Value<DateTime?> pausedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion(
                id: id,
                intention: intention,
                plannedDurationSec: plannedDurationSec,
                actualDurationSec: actualDurationSec,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                pauseCount: pauseCount,
                pausedTotalSec: pausedTotalSec,
                pausedAt: pausedAt,
                syncedAt: syncedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> intention = const Value.absent(),
                required int plannedDurationSec,
                Value<int> actualDurationSec = const Value.absent(),
                required String status,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> pauseCount = const Value.absent(),
                Value<int> pausedTotalSec = const Value.absent(),
                Value<DateTime?> pausedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion.insert(
                id: id,
                intention: intention,
                plannedDurationSec: plannedDurationSec,
                actualDurationSec: actualDurationSec,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                pauseCount: pauseCount,
                pausedTotalSec: pausedTotalSec,
                pausedAt: pausedAt,
                syncedAt: syncedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FocusSessionsTable, FocusSessionRow>(table),
                  $$FocusSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reflectionEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (reflectionEntriesRefs) db.reflectionEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reflectionEntriesRefs)
                    await $_getPrefetchedData<
                      FocusSessionRow,
                      $FocusSessionsTable,
                      ReflectionEntryRow
                    >(
                      currentTable: table,
                      referencedTable: $$FocusSessionsTableReferences
                          ._reflectionEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FocusSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).reflectionEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FocusSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusSessionsTable,
      FocusSessionRow,
      $$FocusSessionsTableFilterComposer,
      $$FocusSessionsTableOrderingComposer,
      $$FocusSessionsTableAnnotationComposer,
      $$FocusSessionsTableCreateCompanionBuilder,
      $$FocusSessionsTableUpdateCompanionBuilder,
      (FocusSessionRow, $$FocusSessionsTableReferences),
      FocusSessionRow,
      PrefetchHooks Function({bool reflectionEntriesRefs})
    >;
typedef $$ReflectionEntriesTableCreateCompanionBuilder =
    ReflectionEntriesCompanion Function({
      required String id,
      Value<String?> sessionId,
      required String promptKey,
      Value<String?> moodTag,
      Value<String?> responseText,
      required DateTime createdAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$ReflectionEntriesTableUpdateCompanionBuilder =
    ReflectionEntriesCompanion Function({
      Value<String> id,
      Value<String?> sessionId,
      Value<String> promptKey,
      Value<String?> moodTag,
      Value<String?> responseText,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

final class $$ReflectionEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReflectionEntriesTable,
          ReflectionEntryRow
        > {
  $$ReflectionEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FocusSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .focusSessions
      .createAlias('reflection_entries__session_id__focus_sessions__id');

  $$FocusSessionsTableProcessedTableManager? get sessionId {
    final $_column = $_itemColumn<String>('session_id');
    if ($_column == null) return null;
    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReflectionEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ReflectionEntriesTable> {
  $$ReflectionEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get promptKey => $composableBuilder(
    column: $table.promptKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moodTag => $composableBuilder(
    column: $table.moodTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responseText => $composableBuilder(
    column: $table.responseText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FocusSessionsTableFilterComposer get sessionId {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReflectionEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReflectionEntriesTable> {
  $$ReflectionEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get promptKey => $composableBuilder(
    column: $table.promptKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moodTag => $composableBuilder(
    column: $table.moodTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responseText => $composableBuilder(
    column: $table.responseText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FocusSessionsTableOrderingComposer get sessionId {
    final $$FocusSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReflectionEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReflectionEntriesTable> {
  $$ReflectionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get promptKey =>
      $composableBuilder(column: $table.promptKey, builder: (column) => column);

  GeneratedColumn<String> get moodTag =>
      $composableBuilder(column: $table.moodTag, builder: (column) => column);

  GeneratedColumn<String> get responseText => $composableBuilder(
    column: $table.responseText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  $$FocusSessionsTableAnnotationComposer get sessionId {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReflectionEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReflectionEntriesTable,
          ReflectionEntryRow,
          $$ReflectionEntriesTableFilterComposer,
          $$ReflectionEntriesTableOrderingComposer,
          $$ReflectionEntriesTableAnnotationComposer,
          $$ReflectionEntriesTableCreateCompanionBuilder,
          $$ReflectionEntriesTableUpdateCompanionBuilder,
          (ReflectionEntryRow, $$ReflectionEntriesTableReferences),
          ReflectionEntryRow,
          PrefetchHooks Function({bool sessionId})
        > {
  $$ReflectionEntriesTableTableManager(
    _$AppDatabase db,
    $ReflectionEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReflectionEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReflectionEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReflectionEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                Value<String> promptKey = const Value.absent(),
                Value<String?> moodTag = const Value.absent(),
                Value<String?> responseText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReflectionEntriesCompanion(
                id: id,
                sessionId: sessionId,
                promptKey: promptKey,
                moodTag: moodTag,
                responseText: responseText,
                createdAt: createdAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> sessionId = const Value.absent(),
                required String promptKey,
                Value<String?> moodTag = const Value.absent(),
                Value<String?> responseText = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReflectionEntriesCompanion.insert(
                id: id,
                sessionId: sessionId,
                promptKey: promptKey,
                moodTag: moodTag,
                responseText: responseText,
                createdAt: createdAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReflectionEntriesTable, ReflectionEntryRow>(
                    table,
                  ),
                  $$ReflectionEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable:
                                    $$ReflectionEntriesTableReferences
                                        ._sessionIdTable(db),
                                referencedColumn:
                                    $$ReflectionEntriesTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReflectionEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReflectionEntriesTable,
      ReflectionEntryRow,
      $$ReflectionEntriesTableFilterComposer,
      $$ReflectionEntriesTableOrderingComposer,
      $$ReflectionEntriesTableAnnotationComposer,
      $$ReflectionEntriesTableCreateCompanionBuilder,
      $$ReflectionEntriesTableUpdateCompanionBuilder,
      (ReflectionEntryRow, $$ReflectionEntriesTableReferences),
      ReflectionEntryRow,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$BlockedAppsTableCreateCompanionBuilder =
    BlockedAppsCompanion Function({
      required String appPackageId,
      Value<int> frictionLevel,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$BlockedAppsTableUpdateCompanionBuilder =
    BlockedAppsCompanion Function({
      Value<String> appPackageId,
      Value<int> frictionLevel,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$BlockedAppsTableFilterComposer
    extends Composer<_$AppDatabase, $BlockedAppsTable> {
  $$BlockedAppsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get appPackageId => $composableBuilder(
    column: $table.appPackageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frictionLevel => $composableBuilder(
    column: $table.frictionLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BlockedAppsTableOrderingComposer
    extends Composer<_$AppDatabase, $BlockedAppsTable> {
  $$BlockedAppsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get appPackageId => $composableBuilder(
    column: $table.appPackageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frictionLevel => $composableBuilder(
    column: $table.frictionLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BlockedAppsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BlockedAppsTable> {
  $$BlockedAppsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get appPackageId => $composableBuilder(
    column: $table.appPackageId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get frictionLevel => $composableBuilder(
    column: $table.frictionLevel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$BlockedAppsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BlockedAppsTable,
          BlockedAppRow,
          $$BlockedAppsTableFilterComposer,
          $$BlockedAppsTableOrderingComposer,
          $$BlockedAppsTableAnnotationComposer,
          $$BlockedAppsTableCreateCompanionBuilder,
          $$BlockedAppsTableUpdateCompanionBuilder,
          (
            BlockedAppRow,
            BaseReferences<_$AppDatabase, $BlockedAppsTable, BlockedAppRow>,
          ),
          BlockedAppRow,
          PrefetchHooks Function()
        > {
  $$BlockedAppsTableTableManager(_$AppDatabase db, $BlockedAppsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlockedAppsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlockedAppsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlockedAppsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> appPackageId = const Value.absent(),
                Value<int> frictionLevel = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BlockedAppsCompanion(
                appPackageId: appPackageId,
                frictionLevel: frictionLevel,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String appPackageId,
                Value<int> frictionLevel = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BlockedAppsCompanion.insert(
                appPackageId: appPackageId,
                frictionLevel: frictionLevel,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BlockedAppsTable, BlockedAppRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BlockedAppsTable,
                    BlockedAppRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BlockedAppsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BlockedAppsTable,
      BlockedAppRow,
      $$BlockedAppsTableFilterComposer,
      $$BlockedAppsTableOrderingComposer,
      $$BlockedAppsTableAnnotationComposer,
      $$BlockedAppsTableCreateCompanionBuilder,
      $$BlockedAppsTableUpdateCompanionBuilder,
      (
        BlockedAppRow,
        BaseReferences<_$AppDatabase, $BlockedAppsTable, BlockedAppRow>,
      ),
      BlockedAppRow,
      PrefetchHooks Function()
    >;
typedef $$DistractionEventsTableCreateCompanionBuilder =
    DistractionEventsCompanion Function({
      required String id,
      required String appPackageId,
      required int frictionLevel,
      required String resolvedAction,
      Value<bool> duringSession,
      Value<String?> reasonText,
      required DateTime occurredAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$DistractionEventsTableUpdateCompanionBuilder =
    DistractionEventsCompanion Function({
      Value<String> id,
      Value<String> appPackageId,
      Value<int> frictionLevel,
      Value<String> resolvedAction,
      Value<bool> duringSession,
      Value<String?> reasonText,
      Value<DateTime> occurredAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$DistractionEventsTableFilterComposer
    extends Composer<_$AppDatabase, $DistractionEventsTable> {
  $$DistractionEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appPackageId => $composableBuilder(
    column: $table.appPackageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frictionLevel => $composableBuilder(
    column: $table.frictionLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resolvedAction => $composableBuilder(
    column: $table.resolvedAction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get duringSession => $composableBuilder(
    column: $table.duringSession,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonText => $composableBuilder(
    column: $table.reasonText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DistractionEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $DistractionEventsTable> {
  $$DistractionEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appPackageId => $composableBuilder(
    column: $table.appPackageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frictionLevel => $composableBuilder(
    column: $table.frictionLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolvedAction => $composableBuilder(
    column: $table.resolvedAction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get duringSession => $composableBuilder(
    column: $table.duringSession,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonText => $composableBuilder(
    column: $table.reasonText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DistractionEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DistractionEventsTable> {
  $$DistractionEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get appPackageId => $composableBuilder(
    column: $table.appPackageId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get frictionLevel => $composableBuilder(
    column: $table.frictionLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resolvedAction => $composableBuilder(
    column: $table.resolvedAction,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get duringSession => $composableBuilder(
    column: $table.duringSession,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasonText => $composableBuilder(
    column: $table.reasonText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$DistractionEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DistractionEventsTable,
          DistractionEventRow,
          $$DistractionEventsTableFilterComposer,
          $$DistractionEventsTableOrderingComposer,
          $$DistractionEventsTableAnnotationComposer,
          $$DistractionEventsTableCreateCompanionBuilder,
          $$DistractionEventsTableUpdateCompanionBuilder,
          (
            DistractionEventRow,
            BaseReferences<
              _$AppDatabase,
              $DistractionEventsTable,
              DistractionEventRow
            >,
          ),
          DistractionEventRow,
          PrefetchHooks Function()
        > {
  $$DistractionEventsTableTableManager(
    _$AppDatabase db,
    $DistractionEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DistractionEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DistractionEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DistractionEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> appPackageId = const Value.absent(),
                Value<int> frictionLevel = const Value.absent(),
                Value<String> resolvedAction = const Value.absent(),
                Value<bool> duringSession = const Value.absent(),
                Value<String?> reasonText = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DistractionEventsCompanion(
                id: id,
                appPackageId: appPackageId,
                frictionLevel: frictionLevel,
                resolvedAction: resolvedAction,
                duringSession: duringSession,
                reasonText: reasonText,
                occurredAt: occurredAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String appPackageId,
                required int frictionLevel,
                required String resolvedAction,
                Value<bool> duringSession = const Value.absent(),
                Value<String?> reasonText = const Value.absent(),
                required DateTime occurredAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DistractionEventsCompanion.insert(
                id: id,
                appPackageId: appPackageId,
                frictionLevel: frictionLevel,
                resolvedAction: resolvedAction,
                duringSession: duringSession,
                reasonText: reasonText,
                occurredAt: occurredAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DistractionEventsTable, DistractionEventRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $DistractionEventsTable,
                    DistractionEventRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DistractionEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DistractionEventsTable,
      DistractionEventRow,
      $$DistractionEventsTableFilterComposer,
      $$DistractionEventsTableOrderingComposer,
      $$DistractionEventsTableAnnotationComposer,
      $$DistractionEventsTableCreateCompanionBuilder,
      $$DistractionEventsTableUpdateCompanionBuilder,
      (
        DistractionEventRow,
        BaseReferences<
          _$AppDatabase,
          $DistractionEventsTable,
          DistractionEventRow
        >,
      ),
      DistractionEventRow,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsTableTableCreateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<String> id,
      Value<int> defaultFrictionLevel,
      Value<int> emergencyLimitPerMonth,
      Value<DateTime?> streakBreakAckedRunEnd,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserSettingsTableTableUpdateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<String> id,
      Value<int> defaultFrictionLevel,
      Value<int> emergencyLimitPerMonth,
      Value<DateTime?> streakBreakAckedRunEnd,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultFrictionLevel => $composableBuilder(
    column: $table.defaultFrictionLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get emergencyLimitPerMonth => $composableBuilder(
    column: $table.emergencyLimitPerMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get streakBreakAckedRunEnd => $composableBuilder(
    column: $table.streakBreakAckedRunEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultFrictionLevel => $composableBuilder(
    column: $table.defaultFrictionLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get emergencyLimitPerMonth => $composableBuilder(
    column: $table.emergencyLimitPerMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get streakBreakAckedRunEnd => $composableBuilder(
    column: $table.streakBreakAckedRunEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get defaultFrictionLevel => $composableBuilder(
    column: $table.defaultFrictionLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get emergencyLimitPerMonth => $composableBuilder(
    column: $table.emergencyLimitPerMonth,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get streakBreakAckedRunEnd => $composableBuilder(
    column: $table.streakBreakAckedRunEnd,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsRow,
          $$UserSettingsTableTableFilterComposer,
          $$UserSettingsTableTableOrderingComposer,
          $$UserSettingsTableTableAnnotationComposer,
          $$UserSettingsTableTableCreateCompanionBuilder,
          $$UserSettingsTableTableUpdateCompanionBuilder,
          (
            UserSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $UserSettingsTableTable,
              UserSettingsRow
            >,
          ),
          UserSettingsRow,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableTableManager(
    _$AppDatabase db,
    $UserSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> defaultFrictionLevel = const Value.absent(),
                Value<int> emergencyLimitPerMonth = const Value.absent(),
                Value<DateTime?> streakBreakAckedRunEnd = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsTableCompanion(
                id: id,
                defaultFrictionLevel: defaultFrictionLevel,
                emergencyLimitPerMonth: emergencyLimitPerMonth,
                streakBreakAckedRunEnd: streakBreakAckedRunEnd,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> defaultFrictionLevel = const Value.absent(),
                Value<int> emergencyLimitPerMonth = const Value.absent(),
                Value<DateTime?> streakBreakAckedRunEnd = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsTableCompanion.insert(
                id: id,
                defaultFrictionLevel: defaultFrictionLevel,
                emergencyLimitPerMonth: emergencyLimitPerMonth,
                streakBreakAckedRunEnd: streakBreakAckedRunEnd,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserSettingsTableTable, UserSettingsRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserSettingsTableTable,
                    UserSettingsRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTableTable,
      UserSettingsRow,
      $$UserSettingsTableTableFilterComposer,
      $$UserSettingsTableTableOrderingComposer,
      $$UserSettingsTableTableAnnotationComposer,
      $$UserSettingsTableTableCreateCompanionBuilder,
      $$UserSettingsTableTableUpdateCompanionBuilder,
      (
        UserSettingsRow,
        BaseReferences<_$AppDatabase, $UserSettingsTableTable, UserSettingsRow>,
      ),
      UserSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$EmergencyOverridesTableCreateCompanionBuilder =
    EmergencyOverridesCompanion Function({
      required String id,
      required DateTime occurredAt,
      required DateTime windowEndsAt,
      Value<DateTime?> partnerNotifiedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$EmergencyOverridesTableUpdateCompanionBuilder =
    EmergencyOverridesCompanion Function({
      Value<String> id,
      Value<DateTime> occurredAt,
      Value<DateTime> windowEndsAt,
      Value<DateTime?> partnerNotifiedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$EmergencyOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $EmergencyOverridesTable> {
  $$EmergencyOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get windowEndsAt => $composableBuilder(
    column: $table.windowEndsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get partnerNotifiedAt => $composableBuilder(
    column: $table.partnerNotifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmergencyOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmergencyOverridesTable> {
  $$EmergencyOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get windowEndsAt => $composableBuilder(
    column: $table.windowEndsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get partnerNotifiedAt => $composableBuilder(
    column: $table.partnerNotifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmergencyOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmergencyOverridesTable> {
  $$EmergencyOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get windowEndsAt => $composableBuilder(
    column: $table.windowEndsAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get partnerNotifiedAt => $composableBuilder(
    column: $table.partnerNotifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$EmergencyOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmergencyOverridesTable,
          EmergencyOverrideRow,
          $$EmergencyOverridesTableFilterComposer,
          $$EmergencyOverridesTableOrderingComposer,
          $$EmergencyOverridesTableAnnotationComposer,
          $$EmergencyOverridesTableCreateCompanionBuilder,
          $$EmergencyOverridesTableUpdateCompanionBuilder,
          (
            EmergencyOverrideRow,
            BaseReferences<
              _$AppDatabase,
              $EmergencyOverridesTable,
              EmergencyOverrideRow
            >,
          ),
          EmergencyOverrideRow,
          PrefetchHooks Function()
        > {
  $$EmergencyOverridesTableTableManager(
    _$AppDatabase db,
    $EmergencyOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmergencyOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmergencyOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmergencyOverridesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> windowEndsAt = const Value.absent(),
                Value<DateTime?> partnerNotifiedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmergencyOverridesCompanion(
                id: id,
                occurredAt: occurredAt,
                windowEndsAt: windowEndsAt,
                partnerNotifiedAt: partnerNotifiedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime occurredAt,
                required DateTime windowEndsAt,
                Value<DateTime?> partnerNotifiedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmergencyOverridesCompanion.insert(
                id: id,
                occurredAt: occurredAt,
                windowEndsAt: windowEndsAt,
                partnerNotifiedAt: partnerNotifiedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmergencyOverridesTable, EmergencyOverrideRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $EmergencyOverridesTable,
                    EmergencyOverrideRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmergencyOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmergencyOverridesTable,
      EmergencyOverrideRow,
      $$EmergencyOverridesTableFilterComposer,
      $$EmergencyOverridesTableOrderingComposer,
      $$EmergencyOverridesTableAnnotationComposer,
      $$EmergencyOverridesTableCreateCompanionBuilder,
      $$EmergencyOverridesTableUpdateCompanionBuilder,
      (
        EmergencyOverrideRow,
        BaseReferences<
          _$AppDatabase,
          $EmergencyOverridesTable,
          EmergencyOverrideRow
        >,
      ),
      EmergencyOverrideRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$ReflectionEntriesTableTableManager get reflectionEntries =>
      $$ReflectionEntriesTableTableManager(_db, _db.reflectionEntries);
  $$BlockedAppsTableTableManager get blockedApps =>
      $$BlockedAppsTableTableManager(_db, _db.blockedApps);
  $$DistractionEventsTableTableManager get distractionEvents =>
      $$DistractionEventsTableTableManager(_db, _db.distractionEvents);
  $$UserSettingsTableTableTableManager get userSettingsTable =>
      $$UserSettingsTableTableTableManager(_db, _db.userSettingsTable);
  $$EmergencyOverridesTableTableManager get emergencyOverrides =>
      $$EmergencyOverridesTableTableManager(_db, _db.emergencyOverrides);
}
