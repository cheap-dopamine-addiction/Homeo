import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/features/friction/data/detected_app_ingest.dart';

/// Listens for `homeo://...` links (iOS Shortcuts automation) and forwards
/// them to [DetectedAppIngest]. Started once from the boot sequence.
class DeepLinkService {
  DeepLinkService(this._ingest);

  final DetectedAppIngest _ingest;
  final AppLinks _links = AppLinks();

  StreamSubscription<Uri>? _subscription;
  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    // The link that launched (or resumed) the app from a cold start.
    try {
      final initial = await _links.getInitialLink();
      if (initial != null) await _ingest.handleDeepLink(initial);
    } catch (e) {
      debugPrint('DeepLinkService initial link failed: $e');
    }

    _subscription = _links.uriLinkStream.listen(
      (uri) => unawaited(_ingest.handleDeepLink(uri)),
      onError: (Object e) => debugPrint('DeepLinkService stream error: $e'),
    );
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _started = false;
  }
}

final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  final service = DeepLinkService(ref.watch(detectedAppIngestProvider));
  ref.onDispose(() => unawaited(service.dispose()));
  return service;
});
