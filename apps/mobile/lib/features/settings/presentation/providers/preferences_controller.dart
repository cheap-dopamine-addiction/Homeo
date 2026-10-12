import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/features/settings/domain/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Owns [AppPreferences]. `load()` runs once from the boot sequence; until
/// then the defaults apply and `loaded` is false.
class PreferencesController extends Notifier<AppPreferences> {
  static const _key = 'homeo.prefs.v1';

  @override
  AppPreferences build() => const AppPreferences();

  Future<void> load() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final raw = sp.getString(_key);
      var loaded = const AppPreferences();
      if (raw != null) {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, Object?>) {
          loaded = AppPreferences.fromJson(decoded);
        }
      }
      state = loaded.copyWith(loaded: true);
    } catch (e) {
      debugPrint('PreferencesController.load failed: $e');
      state = state.copyWith(loaded: true);
    }
  }

  /// Applies [change] immediately, then persists (best effort).
  Future<void> update(AppPreferences Function(AppPreferences) change) async {
    state = change(state);
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.setString(_key, jsonEncode(state.toJson()));
    } catch (e) {
      debugPrint('PreferencesController.update failed: $e');
    }
  }
}

final preferencesProvider =
    NotifierProvider<PreferencesController, AppPreferences>(
      PreferencesController.new,
    );
