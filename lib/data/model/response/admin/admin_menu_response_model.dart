import 'dart:convert';

class MenuResponseModel {
    final List<Menu> data;

    MenuResponseModel({
        required this.data,
    });

    factory MenuResponseModel.fromJson(String str) => MenuResponseModel.fromMap(json.decode(str));

    factory MenuResponseModel.fromMap(List<dynamic> json) => MenuResponseModel(
        data: List<Menu>.from(json.map((x) => Menu.fromMap(x))),
    );
}

class Menu {
    final int id;
    final String name;
    final String? description;
    final double price;
    final String? image;
    final DateTime createdAt;
    final DateTime updatedAt;
    final String? imageUrl;

    Menu({
        required this.id,
        required this.name,
        this.description,
        required this.price,
        this.image,
        required this.createdAt,
        required this.updatedAt,
        this.imageUrl,
    });

    factory Menu.fromMap(Map<String, dynamic> json) => Menu(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: double.tryParse(json["price"].toString()) ?? 0.0,
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        imageUrl: json["image_url"]
    );
}