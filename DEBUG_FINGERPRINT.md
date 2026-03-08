# Debug: Vân tay không hoạt động

## 🔍 Các bước kiểm tra

### 1. Chạy app với log
```bash
flutter run -v
```

Khi vào màn hình đăng nhập, xem log trong console. Bạn sẽ thấy:

✅ **Nếu hoạt động:**
```
🔍 Biometric available: true
🔐 Auto-triggering biometric authentication...
👆 Requesting biometric authentication...
[Popup vân tay hiện ra]
✅ Biometric result: true (nếu thành công)
```

❌ **Nếu không hoạt động:**
```
🔍 Biometric available: false
⚠️ Biometric not available - check if fingerprint/face is set up in device settings
```

### 2. Kiểm tra thiết bị

#### Android:
1. Vào **Cài đặt** > **Bảo mật**
2. Tìm **Vân tay** hoặc **Fingerprint**
3. Đảm bảo đã thêm **ít nhất 1 vân tay**
4. Nếu chưa có → Thêm vân tay mới

#### iOS:
1. Vào **Cài đặt** > **Touch ID & Passcode** (hoặc **Face ID & Passcode**)
2. Đảm bảo đã thiết lập Touch ID hoặc Face ID
3. Nếu chưa có → Thiết lập mới

### 3. Test trên thiết bị thật

⚠️ **Emulator thường KHÔNG hỗ trợ sinh trắc học**

- Chạy trên **thiết bị thật** để test
- Kết nối điện thoại qua USB
- Enable USB Debugging
- Chạy: `flutter run`

### 4. Kiểm tra quyền

#### Android - AndroidManifest.xml
Đảm bảo có các quyền này:
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
```

#### iOS - Info.plist
Đảm bảo có:
```xml
<key>NSFaceIDUsageDescription</key>
<string>Ứng dụng cần sử dụng Face ID để xác thực và bảo mật</string>
```

### 5. Test thủ công

Trên màn hình đăng nhập:
1. Tìm **icon vân tay** (🖐️) ở giữa màn hình
2. Bấm vào icon
3. Popup vân tay sẽ hiện ra

Nếu **KHÔNG thấy icon vân tay** = Thiết bị không hỗ trợ hoặc chưa thiết lập

### 6. Lỗi thường gặp

#### Lỗi 1: "Biometric not available"
**Nguyên nhân:**
- Chưa thiết lập vân tay/Face ID trong Cài đặt
- Đang dùng emulator

**Giải pháp:**
- Thiết lập vân tay trong **Cài đặt** thiết bị
- Chạy trên thiết bị thật

#### Lỗi 2: "Authentication canceled"
**Nguyên nhân:**
- User bấm Cancel
- Vân tay không khớp

**Giải pháp:**
- Thử lại bằng cách bấm icon vân tay
- Hoặc nhập PIN

#### Lỗi 3: Icon vân tay không hiện
**Nguyên nhân:**
- `_biometricAvailable = false`
- Thiết bị không hỗ trợ

**Giải pháp:**
- Kiểm tra log xem tại sao `available = false`
- Đảm bảo đã thiết lập vân tay trong Cài đặt

### 7. Code debug

Nếu muốn debug sâu hơn, thêm code này vào `auth_service.dart`:

```dart
Future<bool> isBiometricAvailable() async {
  try {
    print('🔍 Checking biometric...');
    final canCheckBiometrics = await _auth.canCheckBiometrics;
    print('📱 canCheckBiometrics: $canCheckBiometrics');
    
    final isDeviceSupported = await _auth.isDeviceSupported();
    print('📱 isDeviceSupported: $isDeviceSupported');
    
    final biometrics = await _auth.getAvailableBiometrics();
    print('📱 Available biometrics: $biometrics');
    
    return canCheckBiometrics && isDeviceSupported;
  } catch (e) {
    print('❌ Error: $e');
    return false;
  }
}
```

## 🎯 Test case hoàn chỉnh

1. ✅ Vào **Cài đặt** → Thêm vân tay
2. ✅ Kết nối điện thoại qua USB
3. ✅ Chạy: `flutter run -v`
4. ✅ Quan sát log console
5. ✅ Vào màn hình đăng nhập
6. ✅ Sẽ thấy:
   - Log: `🔍 Biometric available: true`
   - Popup vân tay tự động hiện ra
   - Hoặc icon vân tay ở giữa màn hình

## 📞 Liên hệ hỗ trợ

Nếu vẫn không hoạt động, gửi:
1. Log console (copy toàn bộ)
2. Loại thiết bị (Samsung, iPhone, etc.)
3. Version Android/iOS
4. Screenshot màn hình đăng nhập

---

**Cập nhật**: 03/03/2026
