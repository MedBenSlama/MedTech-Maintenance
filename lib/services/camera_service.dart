import 'package:image_picker/image_picker.dart';

class CameraService {
  static final ImagePicker _picker = ImagePicker();

  // Prendre une photo avec la caméra
  static Future<String?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      return photo?.path;
    } catch (e) {
      print('Erreur camera: $e');
      return null;
    }
  }

  // Choisir depuis la galerie
  static Future<String?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      return image?.path;
    } catch (e) {
      print('Erreur galerie: $e');
      return null;
    }
  }
}
