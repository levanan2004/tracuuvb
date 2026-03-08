# Hướng dẫn thiết lập MilDoc

## 🔧 Cấu hình cho Android

### 1. Cấu hình quyền trong AndroidManifest.xml

File: `android/app/src/main/AndroidManifest.xml`

Đã được tự động cấu hình các quyền cần thiết bởi các plugin:
- `USE_BIOMETRIC` - Cho sinh trắc học
- `INTERNET` - Không bắt buộc (cho debug)
- Các quyền storage cho Isar database

### 2. Cấu hình minSdkVersion

File: `android/app/build.gradle.kts`

Đảm bảo `minSdk >= 21` (Android 5.0):

```kotlin
android {
    defaultConfig {
        minSdk = 21
        targetSdk = 34
    }
}
```

### 3. Cấu hình ProGuard (cho release build)

Nếu gặp lỗi khi build release, thêm vào `android/app/proguard-rules.pro`:

```
-keep class io.isar.** { *; }
-keep @io.isar.annotation.Collection class * { *; }
-dontwarn io.isar.**
```

## 🍎 Cấu hình cho iOS

### 1. Cấu hình quyền trong Info.plist

File: `ios/Runner/Info.plist`

Thêm mô tả cho Face ID:

```xml
<key>NSFaceIDUsageDescription</key>
<string>Sử dụng Face ID để xác thực truy cập ứng dụng</string>
```

### 2. Cấu hình iOS Deployment Target

Đảm bảo iOS deployment target >= 12.0 trong:
- Xcode: Runner > General > Deployment Info
- Hoặc file `ios/Podfile`:

```ruby
platform :ios, '12.0'
```

### 3. Chạy pod install

```bash
cd ios
pod install
cd ..
```

## 🖥️ Cấu hình cho Windows/Linux/macOS Desktop

Các plugin đã hỗ trợ desktop, nhưng một số tính năng có thể bị hạn chế:

### Windows
- ✅ Database (Isar)
- ✅ Secure Storage
- ⚠️ Biometric (có hạn chế, cần Windows Hello)

### Linux
- ✅ Database (Isar)
- ✅ Secure Storage
- ❌ Biometric (chưa hỗ trợ)

### macOS
- ✅ Database (Isar)
- ✅ Secure Storage
- ✅ Biometric (Touch ID)

## 🚀 Chạy ứng dụng

### Development Mode

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Chọn device cụ thể
flutter devices
flutter run -d <device-id>
```

### Release Mode (hiệu suất tốt hơn)

```bash
flutter run --release
```

## 🏗️ Build Production

### Android APK

```bash
# Build APK đơn (universal)
flutter build apk --release

# Build APK theo từng ABI (giảm kích thước)
flutter build apk --split-per-abi

# Kết quả tại: build/app/outputs/flutter-apk/
```

### Android App Bundle (AAB)

```bash
flutter build appbundle --release

# Kết quả tại: build/app/outputs/bundle/release/
```

### iOS IPA

```bash
flutter build ios --release

# Sau đó mở Xcode để archive và export IPA
open ios/Runner.xcworkspace
```

## 🐛 Troubleshooting

### Lỗi: "Isar schema not found"

Chạy lại code generator:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Lỗi: "No implementation found for method..."

1. Clean project:
```bash
flutter clean
flutter pub get
```

2. Với iOS, chạy thêm:
```bash
cd ios && pod install && cd ..
```

### Lỗi biometric không hoạt động

**Android:**
- Kiểm tra device có hỗ trợ fingerprint/face
- Đảm bảo đã setup fingerprint trong Settings

**iOS:**
- Kiểm tra device có Face ID/Touch ID
- Đảm bảo đã thêm NSFaceIDUsageDescription vào Info.plist

### Lỗi secure storage

**Android:**
- Yêu cầu API level >= 21
- Nếu test trên emulator, dùng emulator có Google Play

**iOS:**
- Yêu cầu iOS >= 12.0

### Lỗi build_runner

```bash
# Xóa cache và build lại
flutter pub run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## 📝 Testing

### Test trên emulator/simulator

**Android Emulator:**
```bash
# List devices
flutter devices

# Run on emulator
flutter run -d emulator-5554
```

**iOS Simulator:**
```bash
# List simulators
xcrun simctl list devices

# Run on simulator
flutter run -d <simulator-id>
```

### Test trên thiết bị thật

**Android:**
1. Bật Developer Options và USB Debugging
2. Kết nối USB
3. Chạy: `flutter run`

**iOS:**
1. Cần Apple Developer Account
2. Chạy Xcode và sign app
3. Trust certificate trên device
4. Chạy: `flutter run`

## 🔐 Bảo mật Production

### 1. Obfuscate code

```bash
flutter build apk --obfuscate --split-debug-info=build/debug-info
```

### 2. Disable debugging

Trong release build, đảm bảo:
- `debugShowCheckedModeBanner: false` (đã có trong code)
- Không có console.log statements
- Không có hardcoded credentials

### 3. Code signing

**Android:**
- Tạo keystore file
- Cấu hình trong `android/key.properties`
- Sign APK/AAB

**iOS:**
- Cần Apple Developer Certificate
- Provisioning Profile
- Sign trong Xcode

## 📊 Performance Tips

1. **Build release mode** cho test hiệu suất thực tế
2. **Profile mode** để debug performance:
   ```bash
   flutter run --profile
   ```
3. **Analyze app size:**
   ```bash
   flutter build apk --analyze-size
   ```

## 🔄 Update Dependencies

Kiểm tra updates:
```bash
flutter pub outdated
```

Update dependencies:
```bash
flutter pub upgrade
```

Update Flutter SDK:
```bash
flutter upgrade
```

## 📱 App Icons và Splash Screen

### Thay đổi App Icon

Sử dụng package `flutter_launcher_icons`:

1. Thêm vào `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
```

2. Generate:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### Thay đổi Splash Screen

Sử dụng package `flutter_native_splash`:

1. Thêm vào `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_native_splash: ^2.3.5

flutter_native_splash:
  color: "#4CAF50"
  image: assets/splash/logo.png
  android: true
  ios: true
```

2. Generate:
```bash
flutter pub run flutter_native_splash:create
```

## 📞 Support

Nếu gặp vấn đề không giải quyết được, vui lòng:

1. Kiểm tra Flutter Doctor:
```bash
flutter doctor -v
```

2. Check Flutter version:
```bash
flutter --version
```

3. Clean và rebuild:
```bash
flutter clean
flutter pub get
flutter run
```

---

**Cập nhật**: 02/03/2026
