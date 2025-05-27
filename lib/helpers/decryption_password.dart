import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';

String asciiToHex(String input) {
  final asciiBytes = ascii.encode(input);
  return asciiBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

String bytesToHex(Uint8List bytes) {
  return bytes
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join()
      .toUpperCase();
}

Uint8List hexToBytes(String hex) {
  final length = hex.length;
  final bytes = Uint8List(length ~/ 2);
  for (var i = 0; i < length; i += 2) {
    bytes[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
  }
  return bytes;
}

String embedSalt(String salt, String data) {
  String result = data;
  int dataIndex = int.tryParse(result.substring(0, 1)) ?? 0;
  int saltIndex = 0;
  dataIndex++;

  while (saltIndex < salt.length && dataIndex < result.length) {
    result = result.substring(0, dataIndex) +
        salt[saltIndex] +
        result.substring(dataIndex);
    dataIndex++;
    saltIndex++;

    if (dataIndex < result.length) {
      int skip = int.tryParse(result.substring(dataIndex, dataIndex + 1)) ?? 0;
      dataIndex += skip + 1;
    }
  }

  if (saltIndex < salt.length) {
    result += salt.substring(saltIndex);
  }

  // Append salt length
  int len = salt.length;
  final lenBytes = Uint8List(2);
  lenBytes[0] = (len % 256);
  lenBytes[1] = (len ~/ 256);
  result += ascii
      .encode(bytesToHex(lenBytes))
      .map((e) => String.fromCharCode(e))
      .join();
  return result;
}

bool verifyPasswordDecrypt(String inputPassword, String encryptedBase64,
    String expectedDecryptedValue) {
  try {
    final key = sha256.convert(utf8.encode(inputPassword)).bytes;
    final encryptedBytes = base64.decode(encryptedBase64);

    final aesKey = encrypt.Key(Uint8List.fromList(key));
    final encrypter =
        encrypt.Encrypter(encrypt.AES(aesKey, mode: encrypt.AESMode.ecb));
    final decrypted = encrypter.decrypt(encrypt.Encrypted(encryptedBytes));

    return decrypted == expectedDecryptedValue;
  } catch (e) {
    print('❌ Decryption failed for password [$inputPassword]: $e');
    return false;
  }
}
