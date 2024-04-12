import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '/constants.dart';

import '/controllers/authentication.dart';
import '/controllers/categories.dart';
import '/controllers/recipes.dart';

import '/models/recipe.dart';

import '../recipe/details.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String title = '', category = 'Chicken';

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // User Data
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(16),
              child: StreamBuilder(
                stream: AuthenticationController.user(
                    FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Text('What are you cooking today?'),
                          ],
                        ),
                        const Spacer(),
                        CachedNetworkImage(
                          imageUrl: snapshot.data!.image,
                          errorWidget: (context, url, error) => Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                              color: Colors.grey,
                            ),
                          ),
                          imageBuilder: (context, imageProvider) => Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                              color: Colors.grey,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Container();
                  }
                },
              ),
            ),

            // Search
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(labelText: 'search...'),
                onChanged: (value) => setState(() => title = value),
              ),
            ),

            // Categories
            Container(
              height: 100,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: StreamBuilder(
                stream: CategoryController.categories,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: const ScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: snapshot.data!.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => CachedNetworkImage(
                        imageUrl: snapshot.data![index].image,
                        imageBuilder: (context, imageProvider) => InkWell(
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () => setState(
                              () => category = snapshot.data![index].name),
                          child: Container(
                            width: 150,
                            height: double.maxFinite,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(12).copyWith(right: 0),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.darken,
                                ),
                              ),
                              boxShadow: [
                                if (category == snapshot.data![index].name)
                                  BoxShadow(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    blurRadius: 10,
                                    blurStyle: BlurStyle.outer,
                                  ),
                              ],
                            ),
                            child: Text(
                              snapshot.data![index].name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.75,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Container();
                  }
                },
              ),
            ),

            // Dishes
            StreamBuilder(
              stream: RecipeController.recipes,
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  List<Recipe> recipes = snapShot.data!.where((element) {
                    if (title.isNotEmpty) {
                      return element.title
                          .toLowerCase()
                          .contains(title.toLowerCase());
                    }

                    return element.category == category;
                  }).toList();

                  if (recipes.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16).copyWith(top: 0),
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: List.generate(
                          recipes.length,
                          (index) {
                            Recipe recipe = recipes[index];

                            return Card(
                              elevation: 5,
                              child: InkWell(
                                onTap: () => page(
                                  context: context,
                                  page: RecipeDetails(recipe: recipe),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 2,
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(12.5),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: recipe.image,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        recipe.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.transparent.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                              imageUrl:
                                  'https://firebasestorage.googleapis.com/v0/b/recipes-252f1.appspot.com/o/sorry.png?alt=media&token=f406d0cc-5e59-477c-ae38-81068eef2e54'),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                            child: Text(
                              'There is no $category Products',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                } else if (snapShot.hasError) {
                  return Center(child: Text(snapShot.error.toString()));
                } else if (snapShot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      );
}
