import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final _authService = AuthService();
  String _currentPin = '';
  String _newPin = '';
  String _confirmPin = '';
  int _step = 1; // 1: current, 2: new, 3: confirm
  bool _isLoading = false;

  String get _stepTitle {
    switch (_step) {
      case 1:
        return 'Nhập mã PIN hiện tại';
      case 2:
        return 'Nhập mã PIN mới';
      case 3:
        return 'Xác nhận mã PIN mới';
      default:
        return '';
    }
  }

  String get _stepDescription {
    switch (_step) {
      case 1:
        return 'Nhập mã PIN 6 số hiện tại của bạn';
      case 2:
        return 'Nhập mã PIN mới 6 số';
      case 3:
        return 'Nhập lại mã PIN mới để xác nhận';
      default:
        return '';
    }
  }

  void _onNumberPressed(String number) {
    setState(() {
      switch (_step) {
        case 1:
          if (_currentPin.length < 6) {
            _currentPin += number;
            if (_currentPin.length == 6) {
              _verifyCurrentPin();
            }
          }
          break;
        case 2:
          if (_newPin.length < 6) {
            _newPin += number;
            if (_newPin.length == 6) {
              setState(() => _step = 3);
            }
          }
          break;
        case 3:
          if (_confirmPin.length < 6) {
            _confirmPin += number;
            if (_confirmPin.length == 6) {
              _changePin();
            }
          }
          break;
      }
    });
  }

  void _onDeletePressed() {
    setState(() {
      switch (_step) {
        case 1:
          if (_currentPin.isNotEmpty) {
            _currentPin = _currentPin.substring(0, _currentPin.length - 1);
          }
          break;
        case 2:
          if (_newPin.isNotEmpty) {
            _newPin = _newPin.substring(0, _newPin.length - 1);
          }
          break;
        case 3:
          if (_confirmPin.isNotEmpty) {
            _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
          }
          break;
      }
    });
  }

  Future<void> _verifyCurrentPin() async {
    setState(() => _isLoading = true);

    try {
      final isValid = await _authService.verifyPin(_currentPin);
      
      if (isValid) {
        setState(() {
          _step = 2;
          _isLoading = false;
        });
      } else {
        _showError('Mã PIN hiện tại không đúng');
        setState(() {
          _currentPin = '';
          _isLoading = false;
        });
      }
    } catch (e) {
      _showError('Lỗi khi xác thực: $e');
      setState(() {
        _currentPin = '';
        _isLoading = false;
      });
    }
  }

  Future<void> _changePin() async {
    if (_newPin.length < 6) {
      _showError('Mã PIN phải có 6 số');
      return;
    }

    if (_newPin != _confirmPin) {
      _showError('Mã PIN không khớp');
      setState(() {
        _confirmPin = '';
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.setPin(_newPin);
      
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã đổi mã PIN thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showError('Lỗi khi đổi mã PIN: $e');
      setState(() {
        _newPin = '';
        _confirmPin = '';
        _step = 2;
        _isLoading = false;
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

  String get _currentStepPin {
    switch (_step) {
      case 1:
        return _currentPin;
      case 2:
        return _newPin;
      case 3:
        return _confirmPin;
      default:
        return '';
    }
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
                        'Đổi mã PIN',
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
                      const SizedBox(height: 40),
                      
                      // Step indicator
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            final stepNumber = index + 1;
                            final isActive = _step == stepNumber;
                            final isDone = _step > stepNumber;
                            
                            return Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDone || isActive 
                                        ? Colors.green 
                                        : Colors.grey.shade300,
                                  ),
                                  child: Center(
                                    child: isDone
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 18,
                                          )
                                        : Text(
                                            '$stepNumber',
                                            style: TextStyle(
                                              color: isActive 
                                                  ? Colors.white 
                                                  : Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                                if (index < 2)
                                  Container(
                                    width: 50,
                                    height: 2,
                                    color: _step > stepNumber 
                                        ? Colors.green 
                                        : Colors.grey.shade300,
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Title
                      Text(
                        _stepTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _stepDescription,
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
                          final isFilled = index < _currentStepPin.length;
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
                      
                      // Reset button for step 2 and 3
                      if (_step > 1)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _currentPin = '';
                              _newPin = '';
                              _confirmPin = '';
                              _step = 1;
                            });
                          },
                          child: const Text(
                            'Bắt đầu lại',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      
                      const Spacer(),
                      
                      // Loading indicator
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
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
}
