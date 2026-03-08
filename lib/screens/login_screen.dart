import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:local_auth/local_auth.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  String _pin = '';
  bool _isLoading = false;
  bool _biometricAvailable = false;
  bool _biometricEnrolled = false;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    try {
      final available = await _authService.isBiometricAvailable();
      print('🔍 Biometric available: $available');
      
      // Check if biometrics are enrolled
      final enrolledBiometrics = await _authService.getAvailableBiometrics();
      print('📱 Enrolled biometrics: $enrolledBiometrics');
      
      // Check if user has enabled biometric in app settings (ĐIỀU KIỆN 3)
      final enabled = await _authService.isBiometricEnabled();
      print('⚙️ Biometric enabled in app: $enabled');
      
      // Check if we've already asked user (first-time onboarding)
      final hasPromptShown = await _authService.hasBiometricPromptBeenShown();
      print('❓ Has shown prompt before: $hasPromptShown');
      
      setState(() {
        _biometricAvailable = available;
        _biometricEnrolled = enrolledBiometrics.isNotEmpty;
        _availableBiometrics = List<BiometricType>.from(enrolledBiometrics);
      });
      
      // ⭐ FIRST TIME ONBOARDING - Ask user if they want to enable biometric
      if (available && enrolledBiometrics.isNotEmpty && !hasPromptShown && !enabled) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('🎯 First time - showing biometric onboarding dialog...');
          _showBiometricOnboardingDialog();
        });
        return; // Don't auto-authenticate yet
      }
      
      // ⭐ CHỈ TỰ ĐỘNG XÁC THỰC NẾU CÓ ĐỦ 3 ĐIỀU KIỆN:
      // 1. Thiết bị hỗ trợ (available)
      // 2. Đã đăng ký vân tay/Face ID (enrolledBiometrics.isNotEmpty)
      // 3. User đã BẬT trong app (enabled)
      if (available && enrolledBiometrics.isNotEmpty && enabled) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('🔐 Auto-triggering biometric authentication (all 3 conditions met)...');
          _authenticateWithBiometric();
        });
      } else if (available && enrolledBiometrics.isEmpty) {
        // Device supports biometric but none enrolled - show guide
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showBiometricSetupGuide();
        });
      } else {
        if (!enabled && available && enrolledBiometrics.isNotEmpty) {
          print('⚠️ Biometric available but disabled by user in settings');
        } else {
          print('⚠️ Biometric not available - check if fingerprint/face is set up in device settings');
        }
      }
    } catch (e) {
      print('❌ Error checking biometric: $e');
    }
  }

  Future<void> _authenticateWithBiometric() async {
    if (!_biometricAvailable) {
      print('⚠️ Biometric not available');
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('👆 Requesting biometric authentication...');
      final success = await _authService.authenticateWithBiometrics();
      print('✅ Biometric result: $success');
      
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (mounted) {
        // Biometric failed or cancelled
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xác thực sinh trắc học không thành công. Vui lòng nhập mã PIN.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('❌ Biometric authentication error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể xác thực sinh trắc học. Vui lòng nhập mã PIN.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onNumberPressed(String number) {
    setState(() {
      if (_pin.length < 6) {
        _pin += number;
        if (_pin.length == 6) {
          _loginWithPin();
        }
      }
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  Future<void> _loginWithPin() async {
    if (_pin.length < 6) {
      _showError('Vui lòng nhập đủ 6 số');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _authService.verifyPin(_pin);
      
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showError('Mã PIN không đúng');
        setState(() => _pin = '');
      }
    } catch (e) {
      _showError('Lỗi khi xác thực: $e');
      setState(() => _pin = '');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showBiometricSetupGuide() {
    final biometricTypeName = _getBiometricTypeText();
    final biometricIcon = _getBiometricIcon();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(biometricIcon, color: Colors.green, size: 30),
            const SizedBox(width: 8),
            Text('Thiết lập $biometricTypeName'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thiết bị của bạn hỗ trợ xác thực sinh trắc học nhưng chưa đăng ký $biometricTypeName.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hướng dẫn:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Vào Cài đặt thiết bị'),
            const Text('• Chọn "Bảo mật" hoặc "Sinh trắc học"'),
            Text('• Thêm $biometricTypeName'),
            const Text('• Quay lại app để sử dụng'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bỏ qua'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await AppSettings.openAppSettings(type: AppSettingsType.security);
              } catch (e) {
                print('Error opening settings: $e');
                // Fallback to general settings
                await AppSettings.openAppSettings();
              }
            },
            icon: const Icon(Icons.settings),
            label: const Text('Mở Cài đặt'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showBiometricOnboardingDialog() async {
    // Lấy loại sinh trắc học có sẵn
    final biometrics = await _authService.getAvailableBiometrics();
    
    String biometricTypeName = 'Vân tay/Face ID';
    IconData biometricIcon = Icons.fingerprint;
    
    if (biometrics.contains(BiometricType.face)) {
      biometricTypeName = 'Nhận diện khuôn mặt';
      biometricIcon = Icons.face;
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      biometricTypeName = 'Vân tay';
      biometricIcon = Icons.fingerprint;
    }
    
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false, // Bắt buộc user phải chọn
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(biometricIcon, color: Colors.green, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Sử dụng $biometricTypeName?',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thiết bị của bạn hỗ trợ xác thực bằng $biometricTypeName.',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildBenefitItem('⚡ Đăng nhập nhanh chóng'),
            _buildBenefitItem('🔐 Bảo mật cao hơn'),
            _buildBenefitItem('✨ Không cần nhớ mã PIN'),
            const SizedBox(height: 12),
            const Text(
              'Bạn có muốn bật tính năng này không?',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 16),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Bạn có thể bật/tắt sau trong Cài đặt',
                      style: TextStyle(fontSize: 11, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // User chọn "Để sau" - mark as shown but don't enable
              await _authService.markBiometricPromptShown();
              Navigator.pop(context);
              print('👋 User skipped biometric onboarding');
            },
            child: const Text('Để sau'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              print('✅ User wants to enable biometric - requesting authentication...');
              
              // Authenticate ngay
              setState(() => _isLoading = true);
              final success = await _authService.authenticateWithBiometrics();
              setState(() => _isLoading = false);
              
              if (success) {
                // Xác thực thành công → Enable và mark as shown
                await _authService.setBiometricEnabled(true);
                await _authService.markBiometricPromptShown();
                
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
                print('🎉 Biometric enabled and user logged in');
              } else {
                // Xác thực thất bại → Chỉ mark as shown, không enable
                await _authService.markBiometricPromptShown();
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Xác thực không thành công. Vui lòng nhập mã PIN.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
                print('❌ Biometric authentication failed during onboarding');
              }
            },
            icon: const Icon(Icons.check),
            label: const Text('Bật ngay'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF2E7D32),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Bảo mật tài khoản',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      
                      // Title
                      const Text(
                        'Xác thực để tiếp tục',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _biometricEnrolled 
                          ? 'Sử dụng sinh trắc học hoặc nhập mã PIN'
                          : 'Nhập mã PIN của bạn để đăng nhập',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // PIN Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          final isFilled = index < _pin.length;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFilled ? Colors.green : Colors.transparent,
                              border: Border.all(
                                color: Colors.green,
                                width: 2,
                              ),
                            ),
                          );
                        }),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Biometric button - only show if enrolled
                      if (_biometricEnrolled)
                        Column(
                          children: [
                            InkWell(
                              onTap: _authenticateWithBiometric,
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  _getBiometricIcon(),
                                  size: 40,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getBiometricLabel(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // "Use PIN" button
                            TextButton.icon(
                              onPressed: () {
                                // Just show PIN pad - do nothing special
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Vui lòng nhập mã PIN bên dưới'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.dialpad, size: 18),
                              label: const Text('Sử dụng mã PIN'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      
                      // Forgot password
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Quên mật khẩu'),
                              content: const Text(
                                'Để đặt lại mật khẩu, vui lòng gỡ cài đặt và cài đặt lại ứng dụng.\n\n'
                                'Lưu ý: Việc này sẽ xóa toàn bộ dữ liệu trong ứng dụng.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Đóng'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      
                      // Setup biometric button (show if device supports but no biometrics enrolled)
                      if (_biometricAvailable && !_biometricEnrolled)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextButton.icon(
                            onPressed: _showBiometricSetupGuide,
                            icon: Icon(_getBiometricIcon(), size: 18),
                            label: Text('Thiết lập ${_getBiometricTypeText()}'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                            ),
                          ),
                        ),
                      
                      const Spacer(),
                      
                      // Loading indicator
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: CircularProgressIndicator(),
                        ),
                      
                      // Custom Numpad
                      if (!_isLoading) _buildNumpad(),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'delete'],
    ];
    
    final keyLabels = {
      '1': '',
      '2': 'ABC',
      '3': 'DEF',
      '4': 'GHI',
      '5': 'JKL',
      '6': 'MNO',
      '7': 'PQRS',
      '8': 'TUV',
      '9': 'WXYZ',
      '0': '',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: keys.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((key) {
                if (key.isEmpty) {
                  return const SizedBox(width: 80, height: 70);
                }
                
                if (key == 'delete') {
                  return SizedBox(
                    width: 80,
                    height: 70,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _onDeletePressed,
                        borderRadius: BorderRadius.circular(40),
                        child: const Center(
                          child: Icon(
                            Icons.backspace_outlined,
                            size: 28,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                
                return SizedBox(
                  width: 80,
                  height: 70,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _onNumberPressed(key),
                      borderRadius: BorderRadius.circular(40),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              key,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                            if (keyLabels[key]!.isNotEmpty)
                              Text(
                                keyLabels[key]!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                  letterSpacing: 1,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getBiometricIcon() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return Icons.face;
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return Icons.fingerprint;
    }
    return Icons.fingerprint; // default
  }

  String _getBiometricLabel() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return 'Nhận diện khuôn mặt';
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Xác thực vân tay';
    }
    return 'Xác thực sinh trắc học';
  }

  String _getBiometricTypeText() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return 'Nhận diện khuôn mặt';
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Vân tay';
    }
    return 'Sinh trắc học';
  }
}
