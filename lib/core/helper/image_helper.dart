import 'package:image_picker/image_picker.dart';

class ImageHelper {
  Future<XFile?> pickFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }
}