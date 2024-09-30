import 'package:encrypt/encrypt.dart' as encrypt;

String encryptUrl(String url, String key) {
  final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(key)));
  final iv = encrypt.IV.fromLength(16);
  final encrypted = encrypter.encrypt(url, iv: iv);
  return encrypted.base64;
}
