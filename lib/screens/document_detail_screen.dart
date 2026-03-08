import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/document.dart';
import 'add_document_screen.dart';

class DocumentDetailScreen extends StatelessWidget {
  final Document document;

  const DocumentDetailScreen({
    super.key,
    required this.document,
  });

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
        title: const Text('Chi tiết văn bản'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Chỉnh sửa',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDocumentScreen(document: document),
                ),
              );
              if (result == true && context.mounted) {
                Navigator.pop(context, true); // Return to list and refresh
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with type
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getTypeColor(document.loaiVanBan),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      document.loaiVanBan,
                      style: TextStyle(
                        color: _getTypeColor(document.loaiVanBan),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Document name
                  Text(
                    document.tenVanBan,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Document number
                  Text(
                    'Số hiệu: ${document.soHieu}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Details section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Issue date
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Ngày ban hành',
                    value: DateFormat('dd/MM/yyyy').format(document.ngayBanHanh),
                  ),
                  const SizedBox(height: 16),
                  
                  // Created at
                  _buildInfoRow(
                    icon: Icons.access_time,
                    label: 'Ngày tạo',
                    value: DateFormat('dd/MM/yyyy HH:mm').format(document.createdAt),
                  ),
                  const SizedBox(height: 24),
                  
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Content section
                  Row(
                    children: [
                      const Icon(
                        Icons.article,
                        color: Colors.green,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Nội dung văn bản',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Content
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      document.noiDung,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                      ),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
