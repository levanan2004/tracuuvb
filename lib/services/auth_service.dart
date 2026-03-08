import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  final _auth = LocalAuthentication();
  
  static const String _pinKey = 'user_pin_hash';
  static const String _pinSetKey = 'pin_is_set';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _biometricPromptShownKey = 'biometric_prompt_shown';

  // Hash PIN using SHA-256
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Check if PIN is set
  Future<bool> isPinSet() async {
    try {
      final isSet = await _storage.read(key: _pinSetKey);
      return isSet == 'true';
    } catch (e) {
      print('Error checking PIN: $e');
      // On error (e.g., emulator issues), assume PIN is not set
      return false;
    }
  }

  // Set PIN (first time setup)
  Future<void> setPin(String pin) async {
    try {
      final hashedPin = _hashPin(pin);
      await _storage.write(key: _pinKey, value: hashedPin);
      await _storage.write(key: _pinSetKey, value: 'true');
    } catch (e) {
      print('Error setting PIN: $e');
      rethrow;
    }
  }

  // Verify PIN
  Future<bool> verifyPin(String pin) async {
    try {
      final storedHash = await _storage.read(key: _pinKey);
      if (storedHash == null) return false;
      
      final inputHash = _hashPin(pin);
      return inputHash == storedHash;
    } catch (e) {
      print('Error verifying PIN: $e');
      return false;
    }
  }

  // Check if biometric is available
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  // Get available biometric types
  Future<List<dynamic>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  // Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    try {
      final isAvailable = await isBiometricAvailable();
      print('🔍 Biometric available check: $isAvailable');
      
      if (!isAvailable) {
        print('❌ Biometric not available');
        return false;
      }

      // Check what biometrics are available
      final availableBiometrics = await getAvailableBiometrics();
      print('📱 Available biometrics: $availableBiometrics');
      
      if (availableBiometrics.isEmpty) {
        print('⚠️ No biometrics enrolled on device');
        return false;
      }

      print('👆 Attempting biometric authentication...');
      final result = await _auth.authenticate(
        localizedReason: 'Xác thực để truy cập MilDoc',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true, // ← CHỈ dùng sinh trắc học, KHÔNG cho dùng mật khẩu thiết bị
          sensitiveTransaction: false,
        ),
      );
      
      print('✅ Authentication result: $result');
      return result;
    } catch (e, stackTrace) {
      print('❌ Biometric authentication error: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  // Check if user has enabled biometric in app settings
  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _storage.read(key: _biometricEnabledKey);
      return value == 'true';
    } catch (e) {
      print('Error checking biometric enabled: $e');
      return false;
    }
  }

  // Set biometric enabled state
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await _storage.write(key: _biometricEnabledKey, value: enabled.toString());
      print('💾 Biometric enabled set to: $enabled');
    } catch (e) {
      print('Error setting biometric enabled: $e');
      rethrow;
    }
  }

  // Check if we've already asked user about biometric
  Future<bool> hasBiometricPromptBeenShown() async {
    try {
      final value = await _storage.read(key: _biometricPromptShownKey);
      return value == 'true';
    } catch (e) {
      print('Error checking biometric prompt: $e');
      return false;
    }
  }

  // Mark that we've asked user about biometric
  Future<void> markBiometricPromptShown() async {
    try {
      await _storage.write(key: _biometricPromptShownKey, value: 'true');
      print('✅ Biometric prompt marked as shown');
    } catch (e) {
      print('Error marking biometric prompt: $e');
      rethrow;
    }
  }

  // Reset PIN (for testing/development)
  Future<void> resetPin() async {
    await _storage.delete(key: _pinKey);
    await _storage.delete(key: _pinSetKey);
  }

  // Clear all authentication data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
