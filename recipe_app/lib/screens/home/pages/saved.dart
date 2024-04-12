import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '/controllers/saved.dart';
import '/controllers/recipes.dart';

import '../recipe/details.dart';

import '/constants.dart';

class Saved extends StatelessWidget {
  const Saved({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(height: 16),

          // Title
          Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(16).copyWith(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saved Items',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text('see what you saved'),
              ],
            ),
          ),

          // Saved
          Expanded(
            child: StreamBuilder(
              stream: SavedController.saved(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => StreamBuilder(
                        stream: RecipeController.recipe(snapshot.data![index]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CachedNetworkImage(
                              imageUrl: snapshot.data!.image,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: double.maxFinite,
                                height: 200,
                                margin: const EdgeInsets.all(16)
                                    .copyWith(bottom: 0),
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.bottomCenter,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.5),
                                  image: DecorationImage(
                                    image: imageProvider,
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
                                child: InkWell(
                                  onTap: () => page(
                                    context: context,
                                    page: RecipeDetails(recipe: snapshot.data!),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      snapshot.data!.title,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      snapshot.data!.title,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    trailing: SavedController.button(
                                        id: snapshot.data!.id),
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.error.toString()));
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return Container();
                          }
                        },
                      ),
                    );
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.transparent.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CachedNetworkImage(
                              imageUrl:
                                  'https://firebasestorage.googleapis.com/v0/b/recipes-252f1.appspot.com/o/sorry.png?alt=media&token=f406d0cc-5e59-477c-ae38-81068eef2e54'),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                            child: Text(
                              'There is no saved recipes right now',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
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
        ],
      );
}
