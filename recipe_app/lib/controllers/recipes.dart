import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/recipe.dart';

import '/constants.dart';

import '/screens/home/home_screen.dart';

class RecipeController {
  static CollectionReference<Map<String, dynamic>> recipesCollection =
      FirebaseFirestore.instance.collection('recipes');

  static Stream<List<Recipe>> recipes = recipesCollection.snapshots().map(
        (query) => query.docs.map((item) => Recipe.fromDoc(item)).toList(),
      );

  static Stream<Recipe> recipe(String id) => recipesCollection
      .doc(id)
      .snapshots()
      .map((query) => Recipe.fromDoc(query));

  static Stream<List<Recipe>> userRecipes(DocumentReference user) =>
      recipesCollection.snapshots().map(
            (query) => query.docs
                .map((item) => Recipe.fromDoc(item))
                .where((element) => element.user == user)
                .toList(),
          );

  static void add({required BuildContext context, required Recipe recipe}) {
    try {
      RecipeController.recipesCollection
          .doc()
          .set(recipe.toJson())
          .then((value) => page(
                context: context,
                page: const HomeScreen(),
                remove: true,
              ))
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added Successfully')),
              ));
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    }
  }

  // Update
  static void update({required BuildContext context, required Recipe recipe}) {
    try {
      RecipeController.recipesCollection
          .doc(recipe.id)
          .update(recipe.toJson())
          .then((value) => page(
                context: context,
                page: const HomeScreen(),
                remove: true,
              ))
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Updated Successfully')),
              ));
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    }
  }

  // Delete
  static void delete({required BuildContext context, required String id}) {
    try {
      RecipeController.recipesCollection
          .doc(id)
          .delete()
          .then((value) => page(
                context: context,
                page: const HomeScreen(),
                remove: true,
              ))
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Deleted Successfully')),
              ));
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    }
  }
}
