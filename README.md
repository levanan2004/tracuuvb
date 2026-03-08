# MilDoc - Hệ thống quản lý và tra cứu văn bản quân sự

## 📱 Giới thiệu

**MilDoc** là ứng dụng di động được xây dựng bằng Flutter, cho phép quản lý và tra cứu văn bản quân sự hoàn toàn offline trên thiết bị di động. Ứng dụng tích hợp bảo mật truy cập bằng mã PIN và sinh trắc học.

## ✨ Tính năng chính

### 🔐 Xác thực bảo mật
- **Mã PIN**: Bảo vệ ứng dụng bằng mã PIN được mã hóa SHA-256
- **Sinh trắc học**: Hỗ trợ đăng nhập bằng vân tay/Face ID (tự động kích hoạt khi mở app)
- **Lưu trữ an toàn**: Sử dụng Flutter Secure Storage để lưu thông tin xác thực

### 📄 Quản lý văn bản
- Thêm văn bản mới với đầy đủ thông tin- **Quét OCR**: Chụp ảnh hoặc chọn ảnh để tự động trích xuất nội dung văn bản- Xem danh sách văn bản
- Xem chi tiết văn bản
- Xóa văn bản
- Lưu trữ hoàn toàn offline

### 🔍 Tìm kiếm và lọc
- Tìm kiếm nhanh theo từ khóa
- Tìm trong tên văn bản, nội dung, và số hiệu
- Lọc theo loại văn bản:
  - Chỉ thị
  - Mệnh lệnh
  - Kế hoạch
  - Thông báo

### 📊 Thông tin văn bản
Mỗi văn bản bao gồm:
- Số hiệu văn bản
- Tên văn bản
- Nội dung chi tiết
- Loại văn bản
- Ngày ban hành
- Ngày tạo

## 🏗️ Kiến trúc hệ thống

```
┌─────────────────────────────────┐
│   Flutter Mobile App (UI)      │
├─────────────────────────────────┤
│   Services Layer                │
│   ├── AuthService              │
│   └── DatabaseService          │
├─────────────────────────────────┤
│   Local Database (Isar)        │
├─────────────────────────────────┤
│   Secure Storage               │
│   (PIN hash + keys)            │
└─────────────────────────────────┘
```

## 🛠️ Công nghệ sử dụng

| Công nghệ | Mục đích |
|-----------|----------|
| **Flutter** | Framework phát triển ứng dụng di động |
| **Isar** | Database NoSQL nhanh, lưu trữ offline |
| **local_auth** | Xác thực sinh trắc học |
| **flutter_secure_storage** | Lưu trữ bảo mật (PIN hash) |
| **crypto** | Mã hóa SHA-256 cho PIN |
| **encrypt** | Mã hóa AES-256 cho nội dung văn bản |
| **intl** | Định dạng ngày tháng |
| **provider** | Quản lý state |
| **google_mlkit_text_recognition** | Nhận diện văn bản OCR từ ảnh |
| **image_picker** | Chụp ảnh và chọn ảnh từ thư viện |

## 📁 Cấu trúc thư mục

```
lib/
├── main.dart                    # Entry point của ứng dụng
├── models/
│   └── document.dart           # Model cho văn bản
├── services/
│   ├── auth_service.dart       # Service xác thực
│   ├── database_service.dart   # Service database
│   ├── encryption_service.dart # Service mã hóa AES-256
│   └── ocr_service.dart        # Service quét văn bản OCR
└── screens/
    ├── create_pin_screen.dart      # Màn hình tạo PIN
    ├── login_screen.dart           # Màn hình đăng nhập
    ├── change_pin_screen.dart      # Màn hình đổi PIN
    ├── document_list_screen.dart   # Màn hình danh sách văn bản
    ├── add_document_screen.dart    # Màn hình thêm văn bản
    └── document_detail_screen.dart # Màn hình chi tiết văn bản
```

## 🚀 Cài đặt và chạy

### Yêu cầu
- Flutter SDK 3.10.7 trở lên
- Dart SDK
- Android Studio / VS Code
- Thiết bị Android/iOS hoặc emulator

### Các bước thực hiện

1. **Clone repository**
```bash
git clone <repository-url>
cd tracuuvb
```

2. **Cài đặt dependencies**
```bash
flutter pub get
```

3. **Generate Isar database code**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Chạy ứng dụng**
```bash
# Chạy trên debug mode
flutter run

# Hoặc chạy trên release mode (hiệu suất tốt hơn)
flutter run --release
```

## 📱 Hướng dẫn sử dụng

### Lần đầu sử dụng

1. **Tạo mã PIN**
   - Mở ứng dụng lần đầu
   - Nhập mã PIN (tối thiểu 4 số)
   - Xác nhận lại mã PIN
   - Nhấn "Tạo mã PIN"

### Đăng nhập

2. **Đăng nhập vào hệ thống**
   - Khi mở app, hệ thống **TỰ ĐỘNG** yêu cầu xác thực sinh trắc học (vân tay/Face ID)
   - Popup quét vân tay hiện ra ngay lập tức (nếu thiết bị hỗ trợ)
   - Hoặc bấm vào **icon vân tay** ở giữa màn hình để quét thủ công
   - Nếu sinh trắc học thất bại hoặc không có, nhập mã PIN 6 số
   - ⚠️ **Lưu ý**: Phải thiết lập vân tay/Face ID trong **Cài đặt** thiết bị trước

### Quản lý văn bản

3. **Thêm văn bản mới**
   - Nhấn nút (+) ở góc dưới bên phải
   - Điền đầy đủ thông tin:
     - Số hiệu văn bản
     - Tên văn bản
     - Loại văn bản
     - Ngày ban hành
     - Nội dung
   - **Quét OCR**: Nhấn biểu tượng scanner ở trường nội dung
     - Chọn "Chụp ảnh" để chụp văn bản trực tiếp
     - Chọn "Chọn từ thư viện" để sử dụng ảnh có sẵn
     - Hệ thống sẽ tự động nhận diện và điền nội dung
   - Nhấn "Lưu văn bản"

4. **Tìm kiếm văn bản**
   - Nhập từ khóa vào thanh tìm kiếm
   - Kết quả sẽ tự động lọc theo từ khóa

5. **Lọc theo loại**
   - Nhấn icon bộ lọc (⋮) trên thanh công cụ
   - Chọn loại văn bản cần lọc

6. **Xem chi tiết**
   - Nhấn vào văn bản trong danh sách
   - Xem đầy đủ thông tin và nội dung

7. **Xóa văn bản**
   - Nhấn menu (⋮) bên cạnh văn bản
   - Chọn "Xóa"
   - Xác nhận xóa

## 🔒 Bảo mật

### Các biện pháp bảo mật hiện tại
- ✅ Mã PIN được băm bằng SHA-256
- ✅ Lưu trữ an toàn bằng Flutter Secure Storage
- ✅ Xác thực sinh trắc học (vân tay/Face ID)
- ✅ Dữ liệu lưu trữ offline trên thiết bị
- ✅ Không gửi dữ liệu qua mạng
- ✅ **Mã hóa nội dung văn bản bằng AES-256**

### Định hướng nâng cấp bảo mật
- ❌ Chống chụp màn hình
- ❌ Phân quyền truy cập theo cấp bậc
- ❌ Auto-lock sau khi không hoạt động
- ❌ Xóa dữ liệu sau nhiều lần nhập sai PIN

## 🧪 Testing

Chạy unit tests:
```bash
flutter test
```

## 📦 Build APK/IPA

### Android (APK)
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APK theo ABI (giảm kích thước)
flutter build apk --split-per-abi
```

### iOS (IPA)
```bash
flutter build ios --release
```

## ⚠️ Lưu ý quan trọng

1. **Mã PIN**: Hãy nhớ mã PIN của bạn. Hiện tại chưa có chức năng khôi phục mã PIN.

2. **Backup dữ liệu**: Dữ liệu lưu trữ trên thiết bị. Hãy backup thường xuyên để tránh mất dữ liệu.

3. **Sinh trắc học**: Yêu cầu thiết bị hỗ trợ và đã cài đặt sinh trắc học.

4. **Hiệu suất**: Với số lượng văn bản lớn (>1000), tốc độ tìm kiếm có thể giảm.

## 🔄 Phiên bản

**Version**: 1.0.0+1

### Changelog

#### v1.0.0 (2026-03-02)
- ✨ Phiên bản đầu tiên
- ✅ Xác thực bằng PIN và sinh trắc học (vân tay/Face ID)
- ✅ Tự động yêu cầu sinh trắc học khi mở app
- ✅ Màn hình đổi PIN với numpad đẹp
- ✅ **Mã hóa nội dung văn bản bằng AES-256** (tự động khi lưu/đọc)
- ✅ Quản lý văn bản offline
- ✅ Tìm kiếm và lọc văn bản
- ✅ Quét văn bản bằng OCR (chụp ảnh/chọn ảnh)
- ✅ Giao diện thân thiện với màu xanh lá chủ đạo

## 🤝 Đóng góp

Dự án này được phát triển cho mục đích nội bộ. Mọi đóng góp và phản hồi đều được chào đón.

## 📞 Liên hệ

Mọi thắc mắc vui lòng liên hệ với đội ngũ phát triển.

## 📄 License

Copyright © 2026 - Bản quyền thuộc về đơn vị phát triển.

---

**Lưu ý**: Ứng dụng này được phát triển cho mục đích quản lý văn bản nội bộ. Vui lòng tuân thủ các quy định về bảo mật thông tin.
#   t r a c u u v b  
 