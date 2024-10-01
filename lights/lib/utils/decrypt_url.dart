import 'dart:developer';

import 'package:encrypt/encrypt.dart' as encrypt;

String decryptUrl(String encryptedData, encrypt.Key key) {
  try {
    final parts = encryptedData.split('|');
    if (parts.length != 2) {
      throw const FormatException('Invalid encrypted data format');
    }

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final iv = encrypt.IV.fromBase64(parts[1]);
    final decrypted = encrypter.decrypt64(parts[0], iv: iv);
    return decrypted;
  } catch (e) {
    log('Error decrypting URL: $e');
    return '';
  }
}
