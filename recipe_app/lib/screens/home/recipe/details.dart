import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '/constants.dart';

import '/controllers/saved.dart';
import '/controllers/authentication.dart';
import '/controllers/follow.dart';

import '/models/user.dart';
import '/models/recipe.dart';

import 'edit.dart';
import '../pages/profile.dart';

class RecipeDetails extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetails({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) => Scaffold(
        // AppBar
        appBar: AppBar(
          title: Text(recipe.title),
          actions: [
            SavedController.button(id: recipe.id),
            StreamBuilder(
              stream: AuthenticationController.user(
                  FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data!.id ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  return IconButton(
                    onPressed: () => page(
                      context: context,
                      page: EditRecipe(recipe: recipe),
                    ),
                    icon: const Icon(Icons.edit),
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),

        // Body
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // - Image
              CachedNetworkImage(
                imageUrl: recipe.image,
                errorWidget: (context, url, error) => Container(),
                imageBuilder: (context, imageProvider) => Container(
                  width: double.maxFinite,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12.5),
                    ),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                  ),
                ),
              ),

              // - Label & Review
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // -- Label
                    Expanded(
                      flex: 3,
                      child: Text(
                        recipe.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // -- Review
                    const Expanded(
                      flex: 2,
                      child: Text(
                        '(13k Reviews)',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // - User
              StreamBuilder(
                stream: recipe.user.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data!.id !=
                          FirebaseAuth.instance.currentUser!.uid) {
                    UserModel user = UserModel.fromJson(snapshot.data!);

                    return Column(
                      children: [
                        ListTile(
                          onTap: () => page(
                            context: context,
                            page: Profile(user: user.id),
                          ),

                          // -- Image
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: user.image,
                              fit: BoxFit.fill,
                            ),
                          ),

                          // -- Name
                          title: Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Follow
                          trailing: FollowedController.elevatedButton(
                              context: context, id: user.id),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return Container();
                  }
                },
              ),

              // - Instructions
              Padding(
                padding: const EdgeInsets.all(16).copyWith(bottom: 0),
                child: const Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Text(recipe.instructions),
              ),

              // - Ingredients
              Padding(
                padding: const EdgeInsets.all(16).copyWith(bottom: 0),
                child: const Text(
                  'Ingredients',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                itemCount: recipe.ingredients.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('*   ${recipe.ingredients[index]}'),
                ),
              )
            ],
          ),
        ),
      );
}
