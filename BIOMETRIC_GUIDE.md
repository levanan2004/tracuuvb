# Hướng dẫn sử dụng chức năng Sinh trắc học (Vân tay / Face ID)

## 🔐 Giới thiệu

Chức năng **Sinh trắc học** giúp bạn đăng nhập nhanh chóng và an toàn vào ứng dụng MilDoc bằng vân tay hoặc Face ID, thay vì phải nhập mã PIN mỗi lần.

## ✨ Tính năng

- ✅ Hỗ trợ vân tay (Fingerprint) trên Android và iOS
- ✅ Hỗ trợ Face ID trên iPhone/iPad
- ✅ Tự động yêu cầu xác thực khi mở app
- ✅ Có thể bật/tắt tùy chọn
- ✅ Fallback về PIN nếu sinh trắc học thất bại

## 📱 Yêu cầu

### Android
- Android 6.0 (Marshmallow) trở lên
- Thiết bị có cảm biến vân tay hoặc Face unlock
- Đã thiết lập ít nhất 1 vân tay/khuôn mặt trong Cài đặt

### iOS
- iOS 12.0 trở lên
- iPhone/iPad có Touch ID hoặc Face ID
- Đã thiết lập Touch ID/Face ID trong Cài đặt

## 🚀 Cách sử dụng

### Lần đầu thiết lập

1. **Tạo mã PIN**
   - Mở ứng dụng lần đầu
   - Nhập mã PIN 6 số
   - Xác nhận lại mã PIN
   - Lưu mã PIN

2. **Đăng nhập lần đầu**
   - Mở app, sẽ hiện màn hình đăng nhập
   - Nếu thiết bị hỗ trợ sinh trắc học, app sẽ **tự động** hiện popup yêu cầu xác thực
   - Đặt ngón tay lên cảm biến hoặc nhìn vào camera (Face ID)
   - Nếu thành công, sẽ vào app ngay lập tức

### Các lần sau

Mỗi khi mở app:
1. App tự động yêu cầu xác thực sinh trắc học
2. Xác thực thành công → Vào app ngay
3. Xác thực thất bại → Có thể nhập PIN để vào

### Bật/Tắt sinh trắc học

Trên màn hình đăng nhập:
1. Tìm switch **"FaceID"** (hoặc "Fingerprint")
2. Bật ON: Kích hoạt ngay lập tức popup xác thực
3. Tắt OFF: Chỉ dùng PIN để đăng nhập

## 💡 Mẹo sử dụng

### ✅ Nên làm:
- Đảm bảo ngón tay/khuôn mặt đã được đăng ký trong Cài đặt thiết bị
- Giữ cảm biến sạch, không bị bẩn hoặc ướt
- Nhìn thẳng vào camera khi dùng Face ID
- Nhớ mã PIN để dự phòng

### ❌ Tránh:
- Dùng ngón tay/khuôn mặt chưa được đăng ký
- Thử nhiều lần liên tục khi thất bại (có thể bị khóa tạm thời)
- Quên mã PIN (cần gỡ app và cài lại nếu quên)

## 🔧 Xử lý sự cố

### Không hiện popup yêu cầu sinh trắc học

**Nguyên nhân:**
- Thiết bị không hỗ trợ
- Chưa thiết lập vân tay/Face ID trong Cài đặt
- App chưa được cấp quyền

**Giải pháp:**
1. Vào **Cài đặt** thiết bị
2. Tìm **Bảo mật** > **Sinh trắc học**
3. Thiết lập ít nhất 1 vân tay hoặc Face ID
4. Khởi động lại app

### Sinh trắc học không nhận

**Nguyên nhân:**
- Ngón tay bị ướt, bẩn
- Khuôn mặt bị che khuất (khẩu trang, mũ, kính)
- Góc nhìn không tốt

**Giải pháp:**
- **Vân tay**: Lau sạch ngón tay và cảm biến, thử lại
- **Face ID**: Tháo khẩu trang/kính, nhìn thẳng vào camera
- Nếu vẫn không được, nhập PIN để vào

### Bị khóa sinh trắc học tạm thời

**Nguyên nhân:**
- Thử nhiều lần thất bại liên tục (thường là 5 lần)

**Giải pháp:**
1. Đợi khoảng 30 giây
2. Nhập PIN để vào app
3. Thử sinh trắc học lại sau

### Muốn tắt sinh trắc học

**Cách làm:**
1. Vào màn hình đăng nhập
2. Tắt switch "FaceID"/"Fingerprint"
3. Từ nay chỉ dùng PIN

## 🔒 Bảo mật

### Dữ liệu sinh trắc học
- ⚠️ App **KHÔNG** lưu trữ dữ liệu sinh trắc học (vân tay/khuôn mặt)
- ✅ Chỉ sử dụng API hệ thống để xác thực
- ✅ Dữ liệu sinh trắc học được bảo vệ bởi chip bảo mật của thiết bị
- ✅ Không gửi dữ liệu qua mạng

### Quyền riêng tư
- Android: Yêu cầu quyền `USE_BIOMETRIC` và `USE_FINGERPRINT`
- iOS: Yêu cầu quyền `NSFaceIDUsageDescription`
- Chỉ dùng để xác thực, không thu thập dữ liệu

## 📊 So sánh với PIN

| Tiêu chí | Sinh trắc học | PIN |
|----------|---------------|-----|
| **Tốc độ** | ⚡ Rất nhanh (1-2 giây) | 🐌 Chậm hơn (5-10 giây) |
| **Tiện lợi** | ✅ Không cần nhớ | ⚠️ Phải nhớ 6 số |
| **Bảo mật** | 🔐 Rất cao (sinh trắc học là duy nhất) | 🔐 Cao (nếu PIN mạnh) |
| **Fallback** | ❌ Cần PIN dự phòng | ✅ Luôn hoạt động |
| **Yêu cầu** | 📱 Phụ thuộc thiết bị | ✅ Luôn có sẵn |

## ⚙️ Cài đặt nâng cao

### Thêm nhiều vân tay

1. Vào **Cài đặt** thiết bị
2. **Bảo mật** > **Vân tay**
3. Thêm vân tay của nhiều ngón tay khác nhau
4. App sẽ tự động hỗ trợ tất cả

### Đổi từ Touch ID sang Face ID (iOS)

- Khi nâng cấp từ iPhone cũ (Touch ID) lên iPhone mới (Face ID)
- App tự động nhận diện và chuyển đổi
- Không cần cài đặt gì thêm

## 🆘 Hỗ trợ

### Câu hỏi thường gặp

**Q: Tôi có cần bật sinh trắc học không?**
A: Không bắt buộc. Bạn có thể chỉ dùng PIN. Nhưng sinh trắc học giúp đăng nhập nhanh hơn.

**Q: Nếu tôi đổi vân tay/Face ID thì sao?**
A: App tự động cập nhật. Không cần cài đặt lại.

**Q: Sinh trắc học có an toàn hơn PIN không?**
A: Cả hai đều an toàn. Sinh trắc học tiện lợi hơn nhưng vẫn cần PIN dự phòng.

**Q: Tôi có thể dùng cả sinh trắc học và PIN không?**
A: Có. Bạn có thể bật sinh trắc học và vẫn dùng PIN khi cần.

### Liên hệ hỗ trợ

Nếu gặp vấn đề:
1. Đọc phần **Xử lý sự cố** ở trên
2. Kiểm tra thiết bị đã thiết lập sinh trắc học chưa
3. Thử khởi động lại app
4. Liên hệ đội ngũ hỗ trợ nếu vẫn gặp lỗi

---

**Cập nhật**: 02/03/2026  
**Phiên bản**: 1.0.0

**Lưu ý**: Tính năng sinh trắc học phụ thuộc vào phần cứng và hệ điều hành của thiết bị. Một số thiết bị cũ có thể không hỗ trợ.
