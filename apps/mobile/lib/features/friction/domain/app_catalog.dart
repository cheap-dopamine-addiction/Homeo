import 'package:flutter/material.dart';

@immutable
class CatalogApp {
  const CatalogApp(
    this.packageId,
    this.displayName,
    this.icon, {
    this.key = '',
    this.brand = const Color(0xFF6C63E0),
  });

  final String packageId;
  final String displayName;
  final IconData icon;

  /// Short id used by the onboarding design (`instagram`, `tiktok`, ...).
  final String key;

  /// Brand colour for the app badge.
  final Color brand;
}

/// Curated list of common high-dopamine apps (PRD §1).
///
/// Android package ids. iOS Screen Time does not expose app ids to the app
/// (it hands back opaque tokens), so the native bridge maps these to
/// whatever the platform needs. Picking from *installed* apps replaces this
/// list once the native blocker exists.
abstract final class AppCatalog {
  static const List<CatalogApp> apps = [
    CatalogApp(
      'com.zhiliaoapp.musically',
      'TikTok',
      Icons.music_note_rounded,
      key: 'tiktok',
      brand: Color(0xFF161823),
    ),
    CatalogApp(
      'com.instagram.android',
      'Instagram',
      Icons.photo_camera_outlined,
      key: 'instagram',
      brand: Color(0xFFE1306C),
    ),
    CatalogApp(
      'com.facebook.katana',
      'Facebook',
      Icons.groups_outlined,
      key: 'facebook',
      brand: Color(0xFF1877F2),
    ),
    CatalogApp(
      'com.google.android.youtube',
      'YouTube',
      Icons.smart_display_outlined,
      key: 'youtube',
      brand: Color(0xFFFF0000),
    ),
    CatalogApp(
      'com.twitter.android',
      'X',
      Icons.alternate_email_rounded,
      key: 'twitter',
      brand: Color(0xFF000000),
    ),
    CatalogApp(
      'com.reddit.frontpage',
      'Reddit',
      Icons.forum_outlined,
      key: 'reddit',
      brand: Color(0xFFFF4500),
    ),
    CatalogApp(
      'jp.naver.line.android',
      'LINE',
      Icons.chat_bubble_outline_rounded,
      key: 'line',
      brand: Color(0xFF00B900),
    ),
    CatalogApp(
      'com.shopee.th',
      'Shopee',
      Icons.shopping_bag_outlined,
      key: 'shopee',
      brand: Color(0xFFEE4D2D),
    ),
    CatalogApp(
      'com.lazada.android',
      'Lazada',
      Icons.shopping_cart_outlined,
      key: 'lazada',
      brand: Color(0xFF0F146D),
    ),
  ];

  /// Falls back to the raw id so an unknown app never shows up blank.
  static String nameOf(String packageId) {
    for (final app in apps) {
      if (app.packageId == packageId) return app.displayName;
    }
    return packageId;
  }

  static CatalogApp? byPackage(String packageId) {
    for (final app in apps) {
      if (app.packageId == packageId) return app;
    }
    return null;
  }

  static CatalogApp? byKey(String key) {
    for (final app in apps) {
      if (app.key == key) return app;
    }
    return null;
  }
}
