import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homeo/core/security/field_cipher.dart';

class _MemoryKeyStore implements KeyStore {
  _MemoryKeyStore(this._key);

  final List<int> _key;

  @override
  Future<List<int>> readOrCreateKey() async => _key;
}

Future<List<int>> _newKey() async =>
    AesGcm.with256bits().newSecretKey().then((k) => k.extractBytes());

void main() {
  test('round-trips text, including Thai', () async {
    final cipher = AesGcmFieldCipher(_MemoryKeyStore(await _newKey()));
    for (final plain in ['good', 'เหนื่อยเกินไป', '']) {
      final stored = await cipher.encrypt(plain);
      expect(stored.startsWith('v1:'), isTrue);
      expect(stored.contains(plain) && plain.isNotEmpty, isFalse);
      expect(await cipher.decrypt(stored), plain);
    }
  });

  test(
    'same plaintext encrypts differently each time (random nonce)',
    () async {
      final cipher = AesGcmFieldCipher(_MemoryKeyStore(await _newKey()));
      expect(
        await cipher.encrypt('great'),
        isNot(await cipher.encrypt('great')),
      );
    },
  );

  test('a different key cannot read it', () async {
    final a = AesGcmFieldCipher(_MemoryKeyStore(await _newKey()));
    final b = AesGcmFieldCipher(_MemoryKeyStore(await _newKey()));
    expect(await b.decrypt(await a.encrypt('secret')), isNull);
  });

  test('tampering is detected', () async {
    final cipher = AesGcmFieldCipher(_MemoryKeyStore(await _newKey()));
    final stored = await cipher.encrypt('secret');

    // Flip one bit in the middle of the payload (nonce ‖ ciphertext ‖ mac).
    final bytes = base64Decode(stored.substring(3));
    bytes[bytes.length ~/ 2] ^= 0x01;
    final tampered = 'v1:${base64Encode(bytes)}';

    expect(await cipher.decrypt(tampered), isNull);
  });

  test('garbage and unprefixed values decrypt to null, not a crash', () async {
    final cipher = AesGcmFieldCipher(_MemoryKeyStore(await _newKey()));
    expect(await cipher.decrypt('plain text'), isNull);
    expect(await cipher.decrypt('v1:not-base64!!'), isNull);
  });
}
