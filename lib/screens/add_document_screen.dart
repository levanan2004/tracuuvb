import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/document.dart';
import '../services/database_service.dart';
import '../services/ocr_service.dart';

class AddDocumentScreen extends StatefulWidget {
  final Document? document; // For editing
  
  const AddDocumentScreen({super.key, this.document});

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _databaseService = DatabaseService();
  final _ocrService = OcrService();
  
  final _soHieuController = TextEditingController();
  final _tenVanBanController = TextEditingController();
  final _noiDungController = TextEditingController();
  
  String _selectedType = DocumentType.chiThi;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    // If editing, populate fields
    if (widget.document != null) {
      _soHieuController.text = widget.document!.soHieu;
      _tenVanBanController.text = widget.document!.tenVanBan;
      _noiDungController.text = widget.document!.noiDung;
      _selectedType = widget.document!.loaiVanBan;
      _selectedDate = widget.document!.ngayBanHanh;
    }
  }

  @override
  void dispose() {
    _soHieuController.dispose();
    _tenVanBanController.dispose();
    _noiDungController.dispose();
    _ocrService.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _showScanOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Quét văn bản',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text('Chụp ảnh'),
              subtitle: const Text('Sử dụng camera để chụp văn bản'),
              onTap: () {
                Navigator.pop(context);
                _scanFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Chọn từ thư viện'),
              subtitle: const Text('Chọn ảnh từ thư viện để quét'),
              onTap: () {
                Navigator.pop(context);
                _scanFromGallery();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _scanFromCamera() async {
    setState(() => _isScanning = true);
    
    try {
      final text = await _ocrService.scanFromCamera();
      
      if (text != null && text.isNotEmpty) {
        setState(() {
          _noiDungController.text = text;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quét văn bản thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không tìm thấy văn bản trong ảnh'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi quét: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }

  Future<void> _scanFromGallery() async {
    setState(() => _isScanning = true);
    
    try {
      final text = await _ocrService.scanFromGallery();
      
      if (text != null && text.isNotEmpty) {
        setState(() {
          _noiDungController.text = text;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quét văn bản thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không tìm thấy văn bản trong ảnh'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi quét: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }

  Future<void> _saveDocument() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final document = widget.document ?? Document();
      document.soHieu = _soHieuController.text.trim();
      document.tenVanBan = _tenVanBanController.text.trim();
      document.noiDung = _noiDungController.text.trim();
      document.loaiVanBan = _selectedType;
      document.ngayBanHanh = _selectedDate;

      if (widget.document != null) {
        await _databaseService.updateDocument(document);
      } else {
        await _databaseService.saveDocument(document);
      }

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.document != null 
              ? 'Đã cập nhật văn bản thành công'
              : 'Đã lưu văn bản thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi lưu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document != null ? 'Chỉnh sửa văn bản' : 'Thêm văn bản'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Số hiệu
            TextFormField(
              controller: _soHieuController,
              decoration: const InputDecoration(
                labelText: 'Số hiệu văn bản *',
                hintText: 'VD: 123/QĐ-BQP',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập số hiệu';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Tên văn bản
            TextFormField(
              controller: _tenVanBanController,
              decoration: const InputDecoration(
                labelText: 'Tên văn bản *',
                hintText: 'Nhập tên văn bản',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập tên văn bản';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Loại văn bản
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Loại văn bản *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: DocumentType.all.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Ngày ban hành
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Ngày ban hành *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                child: Text(
                  DateFormat('dd/MM/yyyy').format(_selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Nội dung
            TextFormField(
              controller: _noiDungController,
              decoration: InputDecoration(
                labelText: 'Nội dung văn bản *',
                hintText: 'Nhập nội dung chi tiết hoặc quét từ ảnh',
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
                suffixIcon: IconButton(
                  icon: _isScanning
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.document_scanner, color: Colors.green),
                  onPressed: _isScanning ? null : _showScanOptions,
                  tooltip: 'Quét văn bản từ ảnh',
                ),
              ),
              maxLines: 10,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập nội dung';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Save button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveDocument,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      widget.document != null ? 'Cập nhật văn bản' : 'Lưu văn bản',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            
            // Info note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tất cả các trường đánh dấu (*) là bắt buộc. Văn bản sẽ được lưu trữ offline trên thiết bị.',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
