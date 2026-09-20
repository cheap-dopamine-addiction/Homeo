import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/local_db/app_database.dart';

/// Provides the singleton [AppDatabase] instance to the widget tree.
///
/// Override in tests:
/// ```dart
/// ProviderScope(
///   overrides: [
///     appDatabaseProvider.overrideWithValue(AppDatabase.forTesting(executor)),
///   ],
///   child: MyApp(),
/// )
/// ```
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) {
    final db = AppDatabase();
    ref.onDispose(db.close);
    return db;
  },
  name: 'appDatabaseProvider',
);
