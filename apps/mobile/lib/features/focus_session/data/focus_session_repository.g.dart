// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_session_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(focusSessionRepository)
final focusSessionRepositoryProvider = FocusSessionRepositoryProvider._();

final class FocusSessionRepositoryProvider
    extends
        $FunctionalProvider<
          FocusSessionRepository,
          FocusSessionRepository,
          FocusSessionRepository
        >
    with $Provider<FocusSessionRepository> {
  FocusSessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'focusSessionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$focusSessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<FocusSessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FocusSessionRepository create(Ref ref) {
    return focusSessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FocusSessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FocusSessionRepository>(value),
    );
  }
}

String _$focusSessionRepositoryHash() =>
    r'424669ea2583dbf101ef2a35f24a07c24ccc39d5';
