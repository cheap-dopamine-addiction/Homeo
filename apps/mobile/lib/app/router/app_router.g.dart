// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Five tabs in a [StatefulShellRoute.indexedStack]: each tab keeps its own
/// navigation stack and widget state when you switch away (a plain
/// `ShellRoute` rebuilds the tab from scratch every time).
///
/// Branch order must match the destination order in [AppShell].
///
/// First launch is redirected to the onboarding flow until
/// `AppPreferences.onboardingDone` is set; the redirect is re-evaluated
/// whenever that flag changes.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Five tabs in a [StatefulShellRoute.indexedStack]: each tab keeps its own
/// navigation stack and widget state when you switch away (a plain
/// `ShellRoute` rebuilds the tab from scratch every time).
///
/// Branch order must match the destination order in [AppShell].
///
/// First launch is redirected to the onboarding flow until
/// `AppPreferences.onboardingDone` is set; the redirect is re-evaluated
/// whenever that flag changes.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Five tabs in a [StatefulShellRoute.indexedStack]: each tab keeps its own
  /// navigation stack and widget state when you switch away (a plain
  /// `ShellRoute` rebuilds the tab from scratch every time).
  ///
  /// Branch order must match the destination order in [AppShell].
  ///
  /// First launch is redirected to the onboarding flow until
  /// `AppPreferences.onboardingDone` is set; the redirect is re-evaluated
  /// whenever that flag changes.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'6d48a328ecb78773c234f814f41251af58d33342';
