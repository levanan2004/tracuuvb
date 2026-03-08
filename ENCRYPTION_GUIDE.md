# Mã hóa Văn bản - Hướng dẫn kỹ thuật

## 🔐 Tổng quan

Ứng dụng MilDoc sử dụng **mã hóa AES-256-CBC** để bảo vệ nội dung văn bản được lưu trữ trên thiết bị. Mã hóa này đảm bảo rằng ngay cả khi kẻ xấu có quyền truy cập vào database, họ cũng không thể đọc được nội dung văn bản.

## 🛡️ Chi tiết kỹ thuật

### Thuật toán mã hóa
- **Thuật toán**: AES (Advanced Encryption Standard)
- **Độ dài khóa**: 256-bit (32 bytes)
- **Mode**: CBC (Cipher Block Chaining)
- **IV**: 128-bit (16 bytes) - Random cho mỗi lần khởi tạo
- **Thư viện**: `encrypt` package v5.0.3

### Cấu trúc bảo mật

```
┌─────────────────────────────────┐
│   Văn bản gốc (Plain Text)      │
└────────────┬────────────────────┘
             │
             ▼
       [AES-256-CBC]
       Key: 256-bit
       IV: 128-bit
             │
             ▼
┌─────────────────────────────────┐
│   Văn bản mã hóa (Encrypted)    │
│   Lưu trong Database (Isar)     │
└─────────────────────────────────┘
             │
             ▼
       Khi đọc ra
             │
             ▼
       [AES-256-CBC Decrypt]
             │
             ▼
┌─────────────────────────────────┐
│   Văn bản gốc (Plain Text)      │
│   Hiển thị cho người dùng       │
└─────────────────────────────────┘
```

## 🔑 Quản lý khóa

### Lưu trữ khóa
- Khóa mã hóa được lưu trong **Flutter Secure Storage**
- Sử dụng `encryptedSharedPreferences` cho Android
- Keychain cho iOS
- **KHÔNG** lưu khóa trong code hoặc SharedPreferences thường

### Khởi tạo khóa
1. **Lần đầu sử dụng**: App tự động tạo khóa random 256-bit
2. **Các lần sau**: Sử dụng lại khóa đã tạo
3. **Khi reset**: Có thể tạo khóa mới (sẽ mất khả năng đọc dữ liệu cũ)

## 📂 Triển khai

### Services

#### 1. EncryptionService
File: `lib/services/encryption_service.dart`

**Chức năng chính:**
- `initialize()`: Khởi tạo hoặc load khóa từ secure storage
- `encryptText(String plainText)`: Mã hóa văn bản
- `decryptText(String encryptedText)`: Giải mã văn bản
- `isEncrypted(String text)`: Kiểm tra văn bản đã mã hóa chưa
- `resetKeys()`: Reset khóa mã hóa (cẩn thận!)

**Example:**
```dart
final encryptionService = EncryptionService();
await encryptionService.initialize();

// Mã hóa
String encrypted = await encryptionService.encryptText('Nội dung bí mật');

// Giải mã
String decrypted = await encryptionService.decryptText(encrypted);
```

#### 2. DatabaseService
File: `lib/services/database_service.dart`

**Tích hợp tự động:**
- Khi `saveDocument()`: Tự động mã hóa trường `noiDung`
- Khi đọc văn bản: Tự động giải mã trường `noiDung`
- Search/Filter: Giải mã trước khi tìm kiếm

**Flow tự động:**
```dart
// Lưu văn bản
await databaseService.saveDocument(document);
// ↓ Tự động mã hóa noiDung
// ↓ Lưu vào database

// Đọc văn bản
List<Document> docs = await databaseService.getAllDocuments();
// ↓ Tự động giải mã noiDung
// ↓ Trả về văn bản plain text
```

## 🔒 Bảo mật

### Những gì được mã hóa
✅ **Nội dung văn bản** (`noiDung` field)

### Những gì KHÔNG mã hóa
- Số hiệu văn bản (`soHieu`)
- Tên văn bản (`tenVanBan`)
- Loại văn bản (`loaiVanBan`)
- Ngày ban hành (`ngayBanHanh`)

**Lý do**: Các field này cần cho search/filter/sort nhanh. Chỉ nội dung nhạy cảm mới cần mã hóa.

## 🔄 Backward Compatibility

### Xử lý dữ liệu cũ
App hỗ trợ dữ liệu cũ chưa mã hóa (trước khi có tính năng này):

```dart
Future<String> decryptText(String encryptedText) async {
  try {
    // Thử giải mã
    return _encrypter.decrypt(encrypted, iv: _iv);
  } catch (e) {
    // Nếu lỗi, có thể là plain text từ version cũ
    // Trả về nguyên văn
    return encryptedText;
  }
}
```

### Migration
Khi nâng cấp từ version cũ:
1. Dữ liệu cũ vẫn đọc được (plain text)
2. Khi user sửa/lưu lại → Tự động mã hóa
3. Dần dần toàn bộ database sẽ được mã hóa

## ⚙️ Cấu hình

### Thay đổi thuật toán (nâng cao)

Trong `encryption_service.dart`:

```dart
// Hiện tại: AES-256-CBC
_encrypter = Encrypter(AES(key, mode: AESMode.cbc));

// Có thể đổi sang:
// AES-256-GCM (tốt hơn, nhưng phức tạp hơn)
_encrypter = Encrypter(AES(key, mode: AESMode.gcm));
```

### Thay đổi độ dài khóa

```dart
// Hiện tại: 256-bit (32 bytes)
final key = Key.fromSecureRandom(32);

// Có thể giảm xuống:
// - 128-bit (16 bytes) - Nhanh hơn, ít an toàn hơn
// - 192-bit (24 bytes) - Trung bình
```

## 🧪 Testing

### Test mã hóa/giải mã

```dart
void main() async {
  final service = EncryptionService();
  await service.initialize();
  
  // Test
  String original = 'Văn bản mật';
  String encrypted = await service.encryptText(original);
  String decrypted = await service.decryptText(encrypted);
  
  assert(original == decrypted);
  print('✅ Encryption test passed!');
}
```

### Test với database

```dart
void main() async {
  final dbService = DatabaseService();
  
  // Tạo văn bản
  final doc = Document()
    ..soHieu = 'TEST001'
    ..tenVanBan = 'Test Document'
    ..noiDung = 'Nội dung bí mật'
    ..loaiVanBan = DocumentType.chiThi
    ..ngayBanHanh = DateTime.now();
  
  // Lưu (tự động mã hóa)
  await dbService.saveDocument(doc);
  
  // Đọc lại (tự động giải mã)
  final saved = await dbService.getDocumentById(doc.id);
  
  assert(saved!.noiDung == 'Nội dung bí mật');
  print('✅ Database encryption test passed!');
}
```

## ⚠️ Cảnh báo quan trọng

### 1. **KHÔNG reset khóa**
```dart
// NGUY HIỂM - Sẽ mất khả năng đọc dữ liệu cũ
await encryptionService.resetKeys();
```

### 2. **Backup khóa**
- Nếu mất khóa = mất toàn bộ dữ liệu
- Flutter Secure Storage tự động backup (qua Google/iCloud)
- Nhưng nếu reinstall app = mất khóa

### 3. **Performance**
- Mã hóa/giải mã có cost về thời gian
- Với văn bản lớn (>10KB) có thể chậm
- Search phải giải mã toàn bộ database (chậm với nhiều văn bản)

## 🚀 Tối ưu hóa

### 1. Caching giải mã
```dart
// TODO: Cache văn bản đã giải mã trong memory
Map<int, String> _decryptedCache = {};
```

### 2. Lazy decryption
```dart
// Chỉ giải mã khi cần hiển thị
// Không giải mã trong list view (chỉ hiển thị metadata)
```

### 3. Background decryption
```dart
// Giải mã trong background thread
// Tránh block UI
```

## 📊 So sánh với phương án khác

| Phương án | Bảo mật | Performance | Độ phức tạp |
|-----------|---------|-------------|-------------|
| **Plain text** | ❌ Rất thấp | ⚡ Rất nhanh | ✅ Rất đơn giản |
| **AES-256** | ✅ Cao | 🐢 Chậm | ⚠️ Trung bình |
| **Database encryption** | ✅✅ Rất cao | ⚡ Nhanh | ⚠️⚠️ Phức tạp |
| **Full device encryption** | ✅✅ Rất cao | ⚡ Nhanh | ❌ Phụ thuộc OS |

**Kết luận**: AES-256 là lựa chọn cân bằng tốt cho app này.

## 🔍 Debug

### Kiểm tra văn bản đã mã hóa chưa

```dart
// Trong database browser, nội dung sẽ là base64:
// "U2FsdGVkX1+..."

// Nếu vẫn đọc được plain text = chưa mã hóa
```

### Log mã hóa/giải mã

```dart
print('🔒 Encrypting: ${plainText.substring(0, 20)}...');
print('📦 Encrypted: ${encrypted.substring(0, 40)}...');
print('🔓 Decrypted: ${decrypted.substring(0, 20)}...');
```

## 📚 Tài liệu tham khảo

- [AES Encryption](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
- [Flutter encrypt package](https://pub.dev/packages/encrypt)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [NIST AES Standard](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf)

---

**Cập nhật**: 02/03/2026  
**Phiên bản**: 1.0.0  
**Tác giả**: MilDoc Development Team
