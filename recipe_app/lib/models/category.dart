import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id, name, image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromJson(DocumentSnapshot json) => CategoryModel(
        id: json.id,
        name: json['name'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {'name': name, 'image': image};
}
