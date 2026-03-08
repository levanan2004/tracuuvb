import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/document.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import 'add_document_screen.dart';
import 'document_detail_screen.dart';
import 'change_pin_screen.dart';

class DocumentListScreen extends StatefulWidget {
  const DocumentListScreen({super.key});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  final _databaseService = DatabaseService();
  final _authService = AuthService();
  final _searchController = TextEditingController();
  List<Document> _documents = [];
  List<Document> _filteredDocuments = [];
  bool _isLoading = true;
  String? _selectedType;
  String _sortBy = 'date_desc'; // Default: newest first

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDocuments() async {
    setState(() => _isLoading = true);
    try {
      final documents = await _databaseService.getSortedDocuments(_sortBy);
      setState(() {
        _documents = documents;
        _filteredDocuments = documents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Lỗi khi tải văn bản: $e');
    }
  }

  Future<void> _sortDocuments(String sortBy) async {
    setState(() {
      _sortBy = sortBy;
      _isLoading = true;
    });
    await _loadDocuments();
    if (_searchController.text.isNotEmpty || _selectedType != null) {
      await _searchDocuments(_searchController.text);
    }
  }

  Future<void> _searchDocuments(String keyword) async {
    if (keyword.isEmpty && _selectedType == null) {
      setState(() => _filteredDocuments = _documents);
      return;
    }

    setState(() => _isLoading = true);
    try {
      List<Document> results;
      
      if (_selectedType != null) {
        results = await _databaseService.filterByType(_selectedType!);
        if (keyword.isNotEmpty) {
          results = results.where((doc) =>
            doc.tenVanBan.toLowerCase().contains(keyword.toLowerCase()) ||
            doc.noiDung.toLowerCase().contains(keyword.toLowerCase()) ||
            doc.soHieu.toLowerCase().contains(keyword.toLowerCase())
          ).toList();
        }
      } else {
        results = await _databaseService.searchDocuments(keyword);
      }
      
      setState(() {
        _filteredDocuments = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Lỗi khi tìm kiếm: $e');
    }
  }

  Future<void> _filterByType(String? type) async {
    setState(() {
      _selectedType = type;
      _isLoading = true;
    });

    try {
      List<Document> results;
      if (type == null) {
        results = await _databaseService.getAllDocuments();
      } else {
        results = await _databaseService.filterByType(type);
      }
      
      setState(() {
        _filteredDocuments = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Lỗi khi lọc: $e');
    }
  }

  Future<void> _deleteDocument(Document document) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa văn bản "${document.tenVanBan}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _databaseService.deleteDocument(document.id);
        _loadDocuments();
        _showSuccess('Đã xóa văn bản');
      } catch (e) {
        _showError('Lỗi khi xóa: $e');
      }
    }
  }

  Future<void> _deleteAllDocuments() async {
    final count = _documents.length;
    if (count == 0) {
      _showError('Không có văn bản nào để xóa');
      return;
    }

    // Step 1: Authenticate first
    final authenticated = await _showAuthenticationDialog();
    if (!authenticated) {
      return; // Authentication failed or cancelled
    }

    // Step 2: Show confirmation dialog after successful authentication
    if (!mounted) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 30),
            SizedBox(width: 8),
            Text('Xóa dữ liệu khẩn cấp'),
          ],
        ),
        content: Text(
          'Bạn có chắc muốn xóa TẤT CẢ $count văn bản?\n\n'
          '⚠️ Hành động này không thể hoàn tác!\n'
          '⚠️ Tất cả dữ liệu sẽ bị xóa vĩnh viễn!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('XÓA TẤT CẢ'),
          ),
        ],
      ),
    );

    // Step 3: Delete if confirmed
    if (confirm == true) {
      try {
        await _databaseService.deleteAllDocuments();
        _loadDocuments();
        _showSuccess('Đã xóa tất cả $count văn bản');
      } catch (e) {
        _showError('Lỗi khi xóa: $e');
      }
    }
  }

  Future<bool> _showAuthenticationDialog() async {
    // Check if biometric is available and enabled
    final biometricAvailable = await _authService.isBiometricAvailable();
    final biometricEnabled = await _authService.isBiometricEnabled();
    final availableBiometrics = await _authService.getAvailableBiometrics();
    
    final canUseBiometric = biometricAvailable && 
                           biometricEnabled && 
                           availableBiometrics.isNotEmpty;

    if (canUseBiometric) {
      // Try biometric first
      try {
        final success = await _authService.authenticateWithBiometrics();
        if (success) {
          return true;
        }
        // If biometric fails, fall back to PIN
        if (!mounted) return false;
        _showError('Xác thực sinh trắc học không thành công. Vui lòng nhập mã PIN.');
      } catch (e) {
        if (!mounted) return false;
        _showError('Không thể xác thực sinh trắc học. Vui lòng nhập mã PIN.');
      }
    }

    // Show PIN dialog
    if (!mounted) return false;
    return await _showPinDialog() ?? false;
  }

  Future<bool?> _showPinDialog() {
    String pin = '';
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Xác thực mã PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Nhập mã PIN để tiếp tục'),
              const SizedBox(height: 20),
              // PIN dots display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < pin.length ? Colors.green : Colors.grey.shade300,
                      border: Border.all(
                        color: index < pin.length ? Colors.green : Colors.grey,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              // Number pad
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  if (index == 9) {
                    return const SizedBox.shrink(); // Empty space
                  } else if (index == 10) {
                    return _buildNumberButton('0', () {
                      if (pin.length < 6) {
                        setState(() => pin += '0');
                        if (pin.length == 6) {
                          _verifyPin(context, pin);
                        }
                      }
                    });
                  } else if (index == 11) {
                    return _buildNumberButton('⌫', () {
                      if (pin.isNotEmpty) {
                        setState(() => pin = pin.substring(0, pin.length - 1));
                      }
                    }, isDelete: true);
                  } else {
                    final number = (index + 1).toString();
                    return _buildNumberButton(number, () {
                      if (pin.length < 6) {
                        setState(() => pin += number);
                        if (pin.length == 6) {
                          _verifyPin(context, pin);
                        }
                      }
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(String text, VoidCallback onPressed, {bool isDelete = false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: isDelete ? Colors.red.shade100 : Colors.grey.shade200,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDelete ? Colors.red : Colors.black87,
        ),
      ),
    );
  }

  Future<void> _verifyPin(BuildContext dialogContext, String pin) async {
    final success = await _authService.verifyPin(pin);
    if (success && mounted) {
      Navigator.pop(dialogContext, true);
    } else if (mounted) {
      Navigator.pop(dialogContext, false);
      _showError('Mã PIN không đúng');
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Future<void> _showChangePinDialog() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePinScreen(),
      ),
    );

    if (result == true && mounted) {
      // Success message already shown by ChangePinScreen
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Chỉ thị':
        return Colors.red;
      case 'Mệnh lệnh':
        return Colors.orange;
      case 'Kế hoạch':
        return Colors.blue;
      case 'Thông báo':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MilDoc'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          // Sort button
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sắp xếp',
            onSelected: _sortDocuments,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'date_desc',
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: _sortBy == 'date_desc' ? Colors.green : Colors.transparent,
                    ),
                    const SizedBox(width: 8),
                    const Text('Ngày mới nhất'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'date_asc',
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: _sortBy == 'date_asc' ? Colors.green : Colors.transparent,
                    ),
                    const SizedBox(width: 8),
                    const Text('Ngày cũ nhất'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'number_asc',
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: _sortBy == 'number_asc' ? Colors.green : Colors.transparent,
                    ),
                    const SizedBox(width: 8),
                    const Text('Số hiệu A-Z'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'number_desc',
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: _sortBy == 'number_desc' ? Colors.green : Colors.transparent,
                    ),
                    const SizedBox(width: 8),
                    const Text('Số hiệu Z-A'),
                  ],
                ),
              ),
            ],
          ),
          // Filter button
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Lọc theo loại',
            onSelected: _filterByType,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('Tất cả'),
              ),
              ...DocumentType.all.map((type) => PopupMenuItem(
                value: type,
                child: Text(type),
              )),
            ],
          ),
          // Settings menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.pushNamed(context, '/settings');
              } else if (value == 'change_pin') {
                _showChangePinDialog();
              } else if (value == 'delete_all') {
                _deleteAllDocuments();
              } else if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Cài đặt'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'change_pin',
                child: Row(
                  children: [
                    Icon(Icons.lock_reset),
                    SizedBox(width: 8),
                    Text('Đổi mã PIN'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Xóa dữ liệu khẩn cấp'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Đăng xuất'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: TextField(
              controller: _searchController,
              onChanged: _searchDocuments,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm văn bản...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchDocuments('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          
          // Filter chip
          if (_selectedType != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text('Lọc: '),
                  Chip(
                    label: Text(_selectedType!),
                    onDeleted: () => _filterByType(null),
                    backgroundColor: _getTypeColor(_selectedType!).withOpacity(0.2),
                  ),
                ],
              ),
            ),
          
          // Document list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredDocuments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isNotEmpty || _selectedType != null
                                  ? 'Không tìm thấy văn bản'
                                  : 'Chưa có văn bản nào',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadDocuments,
                        child: ListView.builder(
                          itemCount: _filteredDocuments.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            final document = _filteredDocuments[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DocumentDetailScreen(document: document),
                                    ),
                                  );
                                  _loadDocuments();
                                },
                                leading: CircleAvatar(
                                  backgroundColor: _getTypeColor(document.loaiVanBan),
                                  child: const Icon(
                                    Icons.description,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  document.tenVanBan,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text('Số hiệu: ${document.soHieu}'),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Ngày: ${DateFormat('dd/MM/yyyy').format(document.ngayBanHanh)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: Colors.blue),
                                          SizedBox(width: 8),
                                          Text('Chỉnh sửa'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Xóa'),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddDocumentScreen(document: document),
                                        ),
                                      );
                                      if (result == true) {
                                        _loadDocuments();
                                      }
                                    } else if (value == 'delete') {
                                      _deleteDocument(document);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDocumentScreen(),
            ),
          );
          _loadDocuments();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
