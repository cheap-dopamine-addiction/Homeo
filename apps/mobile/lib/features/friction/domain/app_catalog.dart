import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class CatalogApp {
  const CatalogApp(this.packageId, this.displayName, this.icon);

  final String packageId;
  final String displayName;
  final IconData icon;
}

/// Curated list of common high-dopamine apps (PRD §1).
///
/// Android package ids. iOS Screen Time does not expose app ids to the app
/// (it hands back opaque tokens), so the native bridge maps these to
/// whatever the platform needs. Picking from *installed* apps replaces this
/// list once the native blocker exists.
abstract final class AppCatalog {
  static const List<CatalogApp> apps = [
    CatalogApp('com.zhiliaoapp.musically', 'TikTok', Icons.music_note_rounded),
    CatalogApp(
      'com.instagram.android',
      'Instagram',
      Icons.photo_camera_outlined,
    ),
    CatalogApp('com.facebook.katana', 'Facebook', Icons.groups_outlined),
    CatalogApp(
      'com.google.android.youtube',
      'YouTube',
      Icons.smart_display_outlined,
    ),
    CatalogApp('com.twitter.android', 'X', Icons.alternate_email_rounded),
    CatalogApp('com.reddit.frontpage', 'Reddit', Icons.forum_outlined),
  ];

  /// Falls back to the raw id so an unknown app never shows up blank.
  static String nameOf(String packageId) {
    for (final app in apps) {
      if (app.packageId == packageId) return app.displayName;
    }
    return packageId;
  }
}
