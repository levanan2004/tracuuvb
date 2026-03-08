import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const String _encryptionKeyStorageKey = 'encryption_key';
  static const String _ivStorageKey = 'encryption_iv';

  Encrypter? _encrypter;
  IV? _iv;

  /// Initialize encryption with stored or new keys
  Future<void> initialize() async {
    try {
      // Try to get existing key
      String? storedKey = await _storage.read(key: _encryptionKeyStorageKey);
      String? storedIV = await _storage.read(key: _ivStorageKey);

      if (storedKey != null && storedIV != null) {
        // Use existing key
        final key = Key.fromBase64(storedKey);
        _iv = IV.fromBase64(storedIV);
        _encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      } else {
        // Generate new key and IV
        await _generateNewKeys();
      }
    } catch (e) {
      print('Error initializing encryption: $e');
      // If error, generate new keys
      await _generateNewKeys();
    }
  }

  /// Generate new encryption keys
  Future<void> _generateNewKeys() async {
    // Generate a 256-bit (32 bytes) key for AES-256
    final key = Key.fromSecureRandom(32);
    
    // Generate a 128-bit (16 bytes) IV for AES
    _iv = IV.fromSecureRandom(16);
    
    // Store keys securely
    await _storage.write(
      key: _encryptionKeyStorageKey,
      value: key.base64,
    );
    await _storage.write(
      key: _ivStorageKey,
      value: _iv!.base64,
    );
    
    _encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  }

  /// Encrypt text using AES-256-CBC
  Future<String> encryptText(String plainText) async {
    if (_encrypter == null || _iv == null) {
      await initialize();
    }

    try {
      final encrypted = _encrypter!.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      print('Error encrypting text: $e');
      rethrow;
    }
  }

  /// Decrypt text using AES-256-CBC
  Future<String> decryptText(String encryptedText) async {
    if (_encrypter == null || _iv == null) {
      await initialize();
    }

    // Check if text is actually encrypted (base64 format)
    // If not, it's plain text from before encryption was added - return as-is
    if (!isEncrypted(encryptedText)) {
      return encryptedText;
    }

    try {
      final encrypted = Encrypted.fromBase64(encryptedText);
      return _encrypter!.decrypt(encrypted, iv: _iv);
    } catch (e) {
      print('Error decrypting text: $e');
      // Return original text if decryption fails
      return encryptedText;
    }
  }

  /// Check if a text is encrypted (base64 encoded)
  bool isEncrypted(String text) {
    try {
      base64.decode(text);
      // Check if it's a valid base64 and has reasonable length for encrypted data
      return text.length > 20 && !text.contains(' ');
    } catch (e) {
      return false;
    }
  }

  /// Reset encryption keys (use with caution - will make existing encrypted data unreadable)
  Future<void> resetKeys() async {
    await _storage.delete(key: _encryptionKeyStorageKey);
    await _storage.delete(key: _ivStorageKey);
    await _generateNewKeys();
  }

  /// Check if encryption is initialized
  bool get isInitialized => _encrypter != null && _iv != null;
}
