import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:local_auth/local_auth.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _authService = AuthService();
  bool _isBiometricEnabled = false;
  bool _biometricAvailable = false;
  bool _biometricEnrolled = false;
  bool _isLoading = true;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final available = await _authService.isBiometricAvailable();
      final enrolled = await _authService.getAvailableBiometrics();
      final enabled = await _authService.isBiometricEnabled();

      setState(() {
        _biometricAvailable = available;
        _biometricEnrolled = enrolled.isNotEmpty;
        _availableBiometrics = List<BiometricType>.from(enrolled);
        _isBiometricEnabled = enabled;
        _isLoading = false;
      });

      print('📊 Settings loaded:');
      print('  - Available: $available');
      print('  - Enrolled: ${enrolled.isNotEmpty}');
      print('  - Biometric types: $enrolled');
      print('  - Enabled: $enabled');
    } catch (e) {
      print('❌ Error loading settings: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      // Khi BẬT → phải xác thực ngay
      print('🔐 User wants to enable biometric, requesting authentication...');
      
      final success = await _authService.authenticateWithBiometrics();
      
      if (success) {
        // Xác thực thành công → LƯU vào storage
        await _authService.setBiometricEnabled(true);
        setState(() => _isBiometricEnabled = true);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Đã bật xác thực sinh trắc học'),
              backgroundColor: Colors.green,
            ),
          );
        }
        print('✅ Biometric enabled and saved');
      } else {
        // Xác thực thất bại → KHÔNG lưu
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Xác thực không thành công. Không thể bật.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        print('❌ Authentication failed, biometric not enabled');
      }
    } else {
      // Khi TẮT → không cần xác thực
      await _authService.setBiometricEnabled(false);
      setState(() => _isBiometricEnabled = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã tắt xác thực sinh trắc học'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      print('🔓 Biometric disabled');
    }
  }

  void _showBiometricSetupGuide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.fingerprint, color: Colors.green, size: 30),
            SizedBox(width: 8),
            Text('Thiết lập Vân tay/Face ID'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thiết bị của bạn hỗ trợ xác thực sinh trắc học nhưng chưa đăng ký vân tay hoặc khuôn mặt.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'Hướng dẫn:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Vào Cài đặt thiết bị'),
            Text('• Chọn "Bảo mật" hoặc "Sinh trắc học"'),
            Text('• Thêm vân tay hoặc thiết lập Face ID'),
            Text('• Quay lại app để sử dụng'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await AppSettings.openAppSettings(type: AppSettingsType.security);
              } catch (e) {
                print('Error opening settings: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SizedBox(height: 16),
                
                // Biometric Section
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(_getBiometricIcon(), color: Colors.green, size: 32),
                        title: Text(
                          _getBiometricTitle(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _getBiometricStatusText(),
                          style: TextStyle(
                            color: _getBiometricStatusColor(),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      
                      if (_biometricAvailable && _biometricEnrolled)
                        SwitchListTile(
                          secondary: const Icon(Icons.security, color: Colors.blue),
                          title: Text('Bật ${_getBiometricTypeText()}'),
                          subtitle: Text(
                            'Sử dụng ${_getBiometricTypeText().toLowerCase()} để đăng nhập nhanh',
                            style: const TextStyle(fontSize: 12),
                          ),
                          value: _isBiometricEnabled,
                          onChanged: _toggleBiometric,
                          activeColor: Colors.green,
                        ),
                      
                      if (_biometricAvailable && !_biometricEnrolled)
                        ListTile(
                          leading: const Icon(Icons.warning, color: Colors.orange),
                          title: const Text('Chưa đăng ký sinh trắc học'),
                          subtitle: const Text(
                            'Thiết bị hỗ trợ nhưng chưa có vân tay/Face ID',
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: TextButton(
                            onPressed: _showBiometricSetupGuide,
                            child: const Text('Thiết lập'),
                          ),
                        ),
                      
                      if (!_biometricAvailable)
                        const ListTile(
                          leading: Icon(Icons.not_interested, color: Colors.grey),
                          title: Text('Không hỗ trợ'),
                          subtitle: Text(
                            'Thiết bị này không hỗ trợ sinh trắc học',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                
                // Info Card
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.blue.shade50,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Thông tin',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Khi bật, app sẽ tự động yêu cầu xác thực sinh trắc học khi mở',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '• Bạn vẫn có thể dùng mã PIN nếu sinh trắc học thất bại',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '• Tắt tính năng này nếu bạn muốn chỉ dùng mã PIN',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Security Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'BẢO MẬT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.lock, color: Colors.orange),
                        title: const Text('Đổi mã PIN'),
                        subtitle: const Text('Thay đổi mã PIN hiện tại'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tính năng đang phát triển'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
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

  String _getBiometricTitle() {
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

  String _getBiometricStatusText() {
    if (!_biometricAvailable) {
      return 'Thiết bị không hỗ trợ';
    } else if (!_biometricEnrolled) {
      String typeText = 'vân tay/Face ID';
      return 'Chưa đăng ký $typeText trong thiết bị';
    } else if (_isBiometricEnabled) {
      return '✓ Đã bật - Sử dụng để đăng nhập';
    } else {
      return 'Có sẵn - Bật để sử dụng';
    }
  }

  Color _getBiometricStatusColor() {
    if (!_biometricAvailable || !_biometricEnrolled) {
      return Colors.grey;
    } else if (_isBiometricEnabled) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }
}
