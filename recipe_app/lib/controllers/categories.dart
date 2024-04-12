import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/category.dart';

class CategoryController {
  static CollectionReference<Map<String, dynamic>> categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  static Stream<List<CategoryModel>> categories =
      categoriesCollection.snapshots().map(
            (query) =>
                query.docs.map((item) => CategoryModel.fromJson(item)).toList(),
          );
}
