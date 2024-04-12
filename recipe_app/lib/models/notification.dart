import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String id, title, description;
  bool readen;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.readen,
  });

  factory NotificationModel.fromJson(DocumentSnapshot json) =>
      NotificationModel(
        id: json.id,
        title: json['title'],
        description: json['description'],
        readen: json['readen'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'readen': readen,
      };
}
