import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';
import 'encryption_service.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Isar? _isar;
  final _encryptionService = EncryptionService();
  bool _encryptionInitialized = false;

  Future<Isar> get isar async {
    if (_isar != null) return _isar!;
    _isar = await _initIsar();
    return _isar!;
  }

  Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    
    // Initialize encryption
    if (!_encryptionInitialized) {
      await _encryptionService.initialize();
      _encryptionInitialized = true;
    }
    
    return await Isar.open(
      [DocumentSchema],
      directory: dir.path,
    );
  }

  // Add or update document (with encryption)
  Future<void> saveDocument(Document document) async {
    final db = await isar;
    
    // Encrypt content before saving
    final encryptedContent = await _encryptionService.encryptText(document.noiDung);
    
    // Create a copy with encrypted content
    final encryptedDoc = Document()
      ..id = document.id
      ..soHieu = document.soHieu
      ..tenVanBan = document.tenVanBan
      ..noiDung = encryptedContent
      ..loaiVanBan = document.loaiVanBan
      ..ngayBanHanh = document.ngayBanHanh
      ..createdAt = document.createdAt;
    
    await db.writeTxn(() async {
      await db.documents.put(encryptedDoc);
    });
  }

  // Get all documents (with decryption)
  Future<List<Document>> getAllDocuments() async {
    final db = await isar;
    final docs = await db.documents.where().sortByNgayBanHanhDesc().findAll();
    return await _decryptDocuments(docs);
  }

  // Get document by ID (with decryption)
  Future<Document?> getDocumentById(int id) async {
    final db = await isar;
    final doc = await db.documents.get(id);
    if (doc == null) return null;
    return await _decryptDocument(doc);
  }

  // Decrypt a single document
  Future<Document> _decryptDocument(Document doc) async {
    try {
      final decryptedContent = await _encryptionService.decryptText(doc.noiDung);
      
      return Document()
        ..id = doc.id
        ..soHieu = doc.soHieu
        ..tenVanBan = doc.tenVanBan
        ..noiDung = decryptedContent
        ..loaiVanBan = doc.loaiVanBan
        ..ngayBanHanh = doc.ngayBanHanh
        ..createdAt = doc.createdAt;
    } catch (e) {
      print('Error decrypting document ${doc.id}: $e');
      // Return original if decryption fails
      return doc;
    }
  }

  // Decrypt multiple documents
  Future<List<Document>> _decryptDocuments(List<Document> docs) async {
    final decryptedDocs = <Document>[];
    for (var doc in docs) {
      decryptedDocs.add(await _decryptDocument(doc));
    }
    return decryptedDocs;
  }

  // Search documents by keyword (searches in tenVanBan and noiDung)
  Future<List<Document>> searchDocuments(String keyword) async {
    if (keyword.isEmpty) return await getAllDocuments();
    
    final db = await isar;
    final lowerKeyword = keyword.toLowerCase();
    
    // Get all documents and decrypt them
    final allDocs = await db.documents.where().findAll();
    final decryptedDocs = await _decryptDocuments(allDocs);
    
    // Filter after decryption (since we can't search encrypted content)
    final filtered = decryptedDocs.where((doc) {
      return doc.tenVanBan.toLowerCase().contains(lowerKeyword) ||
             doc.noiDung.toLowerCase().contains(lowerKeyword) ||
             doc.soHieu.toLowerCase().contains(lowerKeyword);
    }).toList();
    
    // Sort by date descending
    filtered.sort((a, b) => b.ngayBanHanh.compareTo(a.ngayBanHanh));
    
    return filtered;
  }

  // Filter documents by type
  Future<List<Document>> filterByType(String loaiVanBan) async {
    final db = await isar;
    final docs = await db.documents
        .filter()
        .loaiVanBanEqualTo(loaiVanBan)
        .sortByNgayBanHanhDesc()
        .findAll();
    return await _decryptDocuments(docs);
  }

  // Update document
  Future<void> updateDocument(Document document) async {
    // Same as save - encrypt before storing
    await saveDocument(document);
  }

  // Delete document
  Future<void> deleteDocument(int id) async {
    final db = await isar;
    await db.writeTxn(() async {
      await db.documents.delete(id);
    });
  }

  // Delete all documents
  Future<void> deleteAllDocuments() async {
    final db = await isar;
    await db.writeTxn(() async {
      await db.documents.clear();
    });
  }

  // Sort documents
  Future<List<Document>> getSortedDocuments(String sortBy) async {
    final db = await isar;
    List<Document> docs;
    
    switch (sortBy) {
      case 'date_desc':
        docs = await db.documents.where().sortByNgayBanHanhDesc().findAll();
        break;
      case 'date_asc':
        docs = await db.documents.where().sortByNgayBanHanh().findAll();
        break;
      case 'number_asc':
        docs = await db.documents.where().sortBySoHieu().findAll();
        break;
      case 'number_desc':
        docs = await db.documents.where().sortBySoHieuDesc().findAll();
        break;
      default:
        docs = await db.documents.where().sortByNgayBanHanhDesc().findAll();
    }
    
    return await _decryptDocuments(docs);
  }

  // Get document count
  Future<int> getDocumentCount() async {
    final db = await isar;
    return await db.documents.count();
  }

  // Close database
  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
