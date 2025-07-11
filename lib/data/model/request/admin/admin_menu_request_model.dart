import 'package:image_picker/image_picker.dart';

class AddMenuRequestModel {
  final String name;
  final String price;
  final String? description;
  final XFile? image;

  AddMenuRequestModel({
    required this.name,
    required this.price,
    this.description,
    this.image,
  });

  // Mengubah data menjadi format Map<String, String> untuk dikirim
  Map<String, String> toMap() {
    return {
      'name': name,
      'price': price,
      if (description != null) 'description': description!,
    };
  }
}