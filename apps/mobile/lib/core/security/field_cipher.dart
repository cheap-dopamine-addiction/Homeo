import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'field_cipher.g.dart';

/// Column-level encryption for High-sensitivity fields (PRD §24.3):
/// reflection mood/text, override reasons.
abstract interface class FieldCipher {
  Future<String> encrypt(String plain);

  /// Null when the value cannot be decrypted (key lost, data tampered with).
  Future<String?> decrypt(String stored);
}

/// Where the 256-bit data key lives.
abstract interface class KeyStore {
  Future<List<int>> readOrCreateKey();
}

/// Key in the platform keystore (Android Keystore / iOS Keychain).
///
/// If the OS keystore is reset (new device without backup, wiped keychain),
/// the key is gone and already-encrypted fields become unreadable — by
/// design. Nothing else in the app depends on those fields to function.
class SecureStorageKeyStore implements KeyStore {
  SecureStorageKeyStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _keyName = 'homeo.field_key.v1';

  final FlutterSecureStorage _storage;

  @override
  Future<List<int>> readOrCreateKey() async {
    final existing = await _storage.read(key: _keyName);
    if (existing != null) return base64Decode(existing);

    final key = await AesGcm.with256bits().newSecretKey();
    final bytes = await key.extractBytes();
    await _storage.write(key: _keyName, value: base64Encode(bytes));
    return bytes;
  }
}

/// AES-256-GCM. Stored format: `v1:` + base64(nonce ‖ ciphertext ‖ mac).
/// A fresh random nonce per value, so equal plaintexts never look equal.
class AesGcmFieldCipher implements FieldCipher {
  AesGcmFieldCipher(this._keys);

  static const _prefix = 'v1:';

  final KeyStore _keys;
  final AesGcm _algorithm = AesGcm.with256bits();

  // Cache the *future* so two concurrent first calls cannot create two keys.
  Future<SecretKey>? _key;

  Future<SecretKey> _secretKey() {
    return _key ??= _keys.readOrCreateKey().then((bytes) => SecretKey(bytes));
  }

  @override
  Future<String> encrypt(String plain) async {
    final box = await _algorithm.encrypt(
      utf8.encode(plain),
      secretKey: await _secretKey(),
    );
    return '$_prefix${base64Encode(box.concatenation())}';
  }

  @override
  Future<String?> decrypt(String stored) async {
    if (!stored.startsWith(_prefix)) return null;
    try {
      final box = SecretBox.fromConcatenation(
        base64Decode(stored.substring(_prefix.length)),
        nonceLength: _algorithm.nonceLength,
        macLength: _algorithm.macAlgorithm.macLength,
      );
      final clear = await _algorithm.decrypt(
        box,
        secretKey: await _secretKey(),
      );
      return utf8.decode(clear);
    } catch (_) {
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
FieldCipher fieldCipher(Ref ref) => AesGcmFieldCipher(SecureStorageKeyStore());
