import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final _authService = AuthService();
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirmMode = false;

  void _onNumberPressed(String number) {
    setState(() {
      if (_isConfirmMode) {
        if (_confirmPin.length < 6) {
          _confirmPin += number;
          if (_confirmPin.length == 6) {
            _verifyAndCreatePin();
          }
        }
      } else {
        if (_pin.length < 6) {
          _pin += number;
          if (_pin.length == 6) {
            // Move to confirm mode
            setState(() => _isConfirmMode = true);
          }
        }
      }
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_isConfirmMode) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }
    });
  }

  Future<void> _verifyAndCreatePin() async {
    if (_pin.length < 6) {
      _showError('Mã PIN phải có 6 số');
      return;
    }

    if (_pin != _confirmPin) {
      _showError('Mã PIN không khớp');
      setState(() {
        _confirmPin = '';
      });
      return;
    }

    try {
      await _authService.setPin(_pin);
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tạo mã PIN thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showError('Lỗi khi tạo mã PIN: $e');
      setState(() {
        _pin = '';
        _confirmPin = '';
        _isConfirmMode = false;
      });
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Bảo mật tài khoản',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
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
                      Text(
                        _isConfirmMode ? 'Xác nhận mật khẩu' : 'Tạo mật khẩu mới',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isConfirmMode 
                            ? 'Nhập mật khẩu mà bạn vừa nhập lại một lần nữa'
                            : 'Nhập mật khẩu 6 chữ số',
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
                          final currentPin = _isConfirmMode ? _confirmPin : _pin;
                          final isFilled = index < currentPin.length;
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
                      
                      // Forgot password
                      if (_isConfirmMode)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _pin = '';
                              _confirmPin = '';
                              _isConfirmMode = false;
                            });
                          },
                          child: const Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      
                      const Spacer(),
                      
                      // Custom Numpad
                      _buildNumpad(),
                      
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
}
