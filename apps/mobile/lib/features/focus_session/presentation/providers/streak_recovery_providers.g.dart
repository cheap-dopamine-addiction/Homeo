// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_recovery_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A just-ended streak the user has not been through recovery for yet, or
/// null. Stays null until both history and settings have loaded, so the
/// recovery screen can never flash up on a half-loaded app.

@ProviderFor(streakBreak)
final streakBreakProvider = StreakBreakProvider._();

/// A just-ended streak the user has not been through recovery for yet, or
/// null. Stays null until both history and settings have loaded, so the
/// recovery screen can never flash up on a half-loaded app.

final class StreakBreakProvider
    extends $FunctionalProvider<StreakBreak?, StreakBreak?, StreakBreak?>
    with $Provider<StreakBreak?> {
  /// A just-ended streak the user has not been through recovery for yet, or
  /// null. Stays null until both history and settings have loaded, so the
  /// recovery screen can never flash up on a half-loaded app.
  StreakBreakProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streakBreakProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streakBreakHash();

  @$internal
  @override
  $ProviderElement<StreakBreak?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StreakBreak? create(Ref ref) {
    return streakBreak(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreakBreak? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreakBreak?>(value),
    );
  }
}

String _$streakBreakHash() => r'23612dbbd36c098e0816b7f7de37f15f7a6cd318';
