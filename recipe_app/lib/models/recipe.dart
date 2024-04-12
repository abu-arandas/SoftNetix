import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String id, title;
  DocumentReference user;
  List<String> ingredients;
  String instructions, category, image;

  Recipe({
    required this.id,
    required this.user,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.image,
  });

  factory Recipe.fromDoc(DocumentSnapshot json) => Recipe(
        id: json.id.toString(),
        user: json['user'],
        title: json['title'].toString(),
        ingredients: List.generate(
          json['ingredients'].length,
          (index) => json['ingredients'][index].toString(),
        ),
        instructions: json['instructions'].toString(),
        category: json['category'].toString(),
        image: 'https:${json['image']}',
      );

  Recipe copyWith({
    DocumentReference? user,
    String? title,
    List<String>? ingredients,
    String? instructions,
    String? category,
    String? image,
  }) =>
      Recipe(
        id: id,
        user: user ?? this.user,
        title: title ?? this.title,
        ingredients: ingredients ?? this.ingredients,
        instructions: instructions ?? this.instructions,
        category: category ?? this.category,
        image: image ?? this.image,
      );

  Map<String, dynamic> toJson() => {
        'user': user,
        'title': title,
        'ingredients': ingredients,
        'instructions': instructions,
        'category': category,
        'image': image,
      };
}
