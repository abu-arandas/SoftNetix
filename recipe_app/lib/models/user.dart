import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name, email;
  String? password;
  String image;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.image =
        'https://firebasestorage.googleapis.com/v0/b/alkhatib-market.appspot.com/o/no-profile-picture-icon.webp?alt=media&token=bfac8dae-344d-4cc9-b763-421a5c0d8988',
  });

  UserModel copyWith({
    String? newName,
    String? newEmail,
    String? newPassword,
    String? newPhone,
    String? newImage,
  }) =>
      UserModel(
        id: id,
        name: newName ?? name,
        email: newEmail ?? email,
        password: newPassword ?? password,
        image: newImage ?? image,
      );

  factory UserModel.fromJson(DocumentSnapshot json) => UserModel(
        id: json.id,
        name: json['name'],
        email: json['email'],
        image: json['image'] ??
            'https://firebasestorage.googleapis.com/v0/b/alkhatib-market.appspot.com/o/no-profile-picture-icon.webp?alt=media&token=bfac8dae-344d-4cc9-b763-421a5c0d8988',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'image': image,
      };
}
