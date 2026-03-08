import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OcrService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final _imagePicker = ImagePicker();

  /// Chụp ảnh từ camera và trích xuất text
  Future<String?> scanFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (image == null) return null;

      return await _extractTextFromImage(image.path);
    } catch (e) {
      throw Exception('Lỗi khi chụp ảnh: $e');
    }
  }

  /// Chọn ảnh từ thư viện và trích xuất text
  Future<String?> scanFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image == null) return null;

      return await _extractTextFromImage(image.path);
    } catch (e) {
      throw Exception('Lỗi khi chọn ảnh: $e');
    }
  }

  /// Trích xuất text từ đường dẫn ảnh
  Future<String?> _extractTextFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      if (recognizedText.text.isEmpty) {
        return null;
      }

      return recognizedText.text;
    } catch (e) {
      throw Exception('Lỗi khi quét văn bản: $e');
    }
  }

  /// Giải phóng tài nguyên
  void dispose() {
    _textRecognizer.close();
  }
}
