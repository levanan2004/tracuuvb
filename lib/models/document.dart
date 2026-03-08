import 'package:isar/isar.dart';

part 'document.g.dart';

@collection
class Document {
  Id id = Isar.autoIncrement;

  @Index()
  late String soHieu; // Document number

  @Index(type: IndexType.value)
  late String tenVanBan; // Document name

  late String noiDung; // Content

  @Index()
  late String loaiVanBan; // Document type: Chỉ thị, Mệnh lệnh, Kế hoạch, Thông báo

  @Index()
  late DateTime ngayBanHanh; // Issue date

  DateTime createdAt = DateTime.now();
}

// Document types enum for reference
class DocumentType {
  static const String chiThi = 'Chỉ thị';
  static const String menhLenh = 'Mệnh lệnh';
  static const String keHoach = 'Kế hoạch';
  static const String thongBao = 'Thông báo';

  static List<String> get all => [chiThi, menhLenh, keHoach, thongBao];
}
