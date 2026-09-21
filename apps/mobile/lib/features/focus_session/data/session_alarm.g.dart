// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_alarm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sessionAlarm)
final sessionAlarmProvider = SessionAlarmProvider._();

final class SessionAlarmProvider
    extends $FunctionalProvider<SessionAlarm, SessionAlarm, SessionAlarm>
    with $Provider<SessionAlarm> {
  SessionAlarmProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionAlarmProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionAlarmHash();

  @$internal
  @override
  $ProviderElement<SessionAlarm> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionAlarm create(Ref ref) {
    return sessionAlarm(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionAlarm value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionAlarm>(value),
    );
  }
}

String _$sessionAlarmHash() => r'483a7ed00ee431837d149fa1446cdc6386023bf7';
