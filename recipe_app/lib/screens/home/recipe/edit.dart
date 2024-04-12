import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '/controllers/authentication.dart';
import '/controllers/categories.dart';
import '/controllers/recipes.dart';

import '/models/recipe.dart';

class EditRecipe extends StatefulWidget {
  final Recipe recipe;
  const EditRecipe({super.key, required this.recipe});

  @override
  State<EditRecipe> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController title = TextEditingController();

  List<String> ingredients = [];
  TextEditingController ingredient = TextEditingController();
  TextEditingController instructions = TextEditingController();

  String category = '',
      image =
          'https://firebasestorage.googleapis.com/v0/b/alkhatib-market.appspot.com/o/no-profile-picture-icon.webp?alt=media&token=bfac8dae-344d-4cc9-b763-421a5c0d8988';

  @override
  void initState() {
    super.initState();

    setState(() {
      title = TextEditingController(text: widget.recipe.title);
      ingredients = widget.recipe.ingredients;
      instructions = TextEditingController(text: widget.recipe.instructions);
      category = widget.recipe.category;
      image = widget.recipe.image;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Edit ${widget.recipe.title}')),
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400,
                minHeight: MediaQuery.sizeOf(context).height,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Container(
                      width: double.maxFinite,
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.5),
                        image: DecorationImage(
                          image: NetworkImage(image),
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.darken,
                          ),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 10,
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                      ),
                      child: IconButton.filled(
                        onPressed: () {
                          if (image.isNotEmpty) {
                            setState(() => image = '');
                          } else {
                            ImagePicker()
                                .pickImage(source: ImageSource.gallery)
                                .then((value) {
                              if (value != null) {
                                FirebaseStorage.instance
                                    .ref()
                                    .child('recipes/')
                                    .putFile(File(value.path))
                                    .then((ref) {
                                  setState(() async =>
                                      image = await ref.ref.getDownloadURL());
                                });
                              }
                            });
                          }
                        },
                        style: IconButton.styleFrom(
                          backgroundColor:
                              image.isNotEmpty ? Colors.red : Colors.grey,
                          foregroundColor:
                              image.isNotEmpty ? Colors.white : Colors.black,
                        ),
                        icon: Icon(
                            image.isNotEmpty ? Icons.remove : Icons.camera_alt),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      'Title',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: title,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* required';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Ingredients
                    Text(
                      'Ingredients',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        ingredients.length,
                        (index) => Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.5),
                            border: Border.all(),
                          ),
                          child: Row(
                            children: [
                              Flexible(child: Text(ingredients[index])),
                              IconButton(
                                onPressed: () =>
                                    setState(() => ingredients.removeAt(index)),
                                icon: const Icon(Icons.remove),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: ingredient,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) {
                        setState(() {
                          ingredients.add(ingredient.text);
                          ingredient = TextEditingController();
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Instructions
                    Text(
                      'Instructions',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: instructions,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* required';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Category
                    Text(
                      'Category:',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder(
                      stream: CategoryController.categories,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Wrap(
                            spacing: 8,
                            children: List.generate(
                              snapshot.data!.length,
                              (index) => category ==
                                      snapshot.data![index].name.toLowerCase()
                                  ? ElevatedButton(
                                      onPressed: () {
                                        setState(() => category = snapshot
                                            .data![index].name
                                            .toLowerCase());
                                      },
                                      child: Text(snapshot.data![index].name),
                                    )
                                  : OutlinedButton(
                                      onPressed: () {
                                        setState(() => category = snapshot
                                            .data![index].name
                                            .toLowerCase());
                                      },
                                      child: Text(snapshot.data![index].name),
                                    ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return Container();
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Add
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () => validator(),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(400, 50),
                        ),
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  void validator() {
    if (formKey.currentState!.validate()) {
      if (image.isNotEmpty) {
        if (category.isNotEmpty) {
          if (ingredients.isNotEmpty) {
            Recipe recipe = Recipe(
              id: '',
              user: AuthenticationController.usersCollection
                  .doc(FirebaseAuth.instance.currentUser!.uid),
              title: title.text,
              ingredients: ingredients,
              instructions: instructions.text,
              category: category,
              image: image,
            );

            RecipeController.update(context: context, recipe: recipe);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ingredients are empty')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('category is required')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('image is required')),
        );
      }
    }
  }
}
