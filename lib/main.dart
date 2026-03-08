import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/auth_service.dart';
import 'screens/create_pin_screen.dart';
import 'screens/login_screen.dart';
import 'screens/document_list_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MilDocApp());
}

// Global navigator key to check navigation state
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MilDocApp extends StatelessWidget {
  const MilDocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'MilDoc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/create-pin': (context) => const CreatePinScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const DocumentListScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

// Splash screen to determine initial route
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AuthService();
  String _status = 'Đang khởi tạo...';
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _checkInitialRoute();
  }

  @override
  void reassemble() {
    super.reassemble();
    // This is called during hot reload - don't navigate again
    print('🔄 Hot reload detected - skipping navigation');
  }

  Future<void> _checkInitialRoute() async {
    // Prevent multiple navigations
    if (_hasNavigated) {
      print('⚠️ Already navigated, skipping...');
      return;
    }
    
    try {
      // Wait a bit for splash effect
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      setState(() => _status = 'Đang kiểm tra bảo mật...');

      // Check if PIN is set with timeout
      final isPinSet = await _authService.isPinSet().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('Timeout checking PIN, assuming not set');
          return false;
        },
      );

      if (!mounted || _hasNavigated) return;

      setState(() => _status = 'Đang chuyển màn hình...');

      // Small delay before navigation
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted || _hasNavigated) return;

      _hasNavigated = true;

      if (isPinSet) {
        // PIN is set, go to login
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // PIN not set, go to create PIN
        Navigator.pushReplacementNamed(context, '/create-pin');
      }
    } catch (e) {
      print('Error in splash screen: $e');
      if (mounted) {
        // On error, go to create PIN screen
        Navigator.pushReplacementNamed(context, '/create-pin');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shield,
                size: 80,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 32),
            // App name
            const Text(
              'MilDoc',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            const Text(
              'Hệ thống quản lý văn bản quân sự',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 16),
            // Status text
            Text(
              _status,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
