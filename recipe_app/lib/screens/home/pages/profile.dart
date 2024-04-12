import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:recipe_app/models/user.dart';

import '/constants.dart';

import '/controllers/authentication.dart';
import '/controllers/recipes.dart';
import '/controllers/follow.dart';

import '../recipe/details.dart';

class Profile extends StatelessWidget {
  final String? user;
  const Profile({super.key, this.user});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: AuthenticationController.user(
            user ?? FirebaseAuth.instance.currentUser!.uid),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text(userSnapshot.data!.name),
                actions: [
                  // User Profile
                  if (user != null) ...{
                    FollowedController.iconButton(id: userSnapshot.data!.id)
                  }

                  // Logged Profile
                  else ...{
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) =>
                            EditProfile(user: userSnapshot.data!),
                      ),
                      icon: const Icon(Icons.logout),
                    ),
                    IconButton(
                      onPressed: () => AuthenticationController.logout(context),
                      icon: const Icon(Icons.logout),
                    ),
                  }
                ],
              ),
              body: Column(
                children: <Widget>[
                  const SizedBox(height: 24),

                  // User Informations
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CachedNetworkImage(
                              imageUrl: userSnapshot.data!.image,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.fill),
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
                            const Spacer(),
                            Column(
                              children: [
                                Text(
                                  userSnapshot.data!.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    // - Recipes
                                    data(title: 'Recipe', data: 4),

                                    // - Followers
                                    data(title: 'Followers', data: 2500000),

                                    // - Following
                                    data(title: 'Following', data: 234),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Recipes
                  Expanded(
                    child: StreamBuilder(
                      stream: RecipeController.recipes,
                      builder: (context, snapShot) {
                        if (snapShot.hasData) {
                          if (snapShot.data!.isNotEmpty) {
                            return Padding(
                              padding:
                                  const EdgeInsets.all(16).copyWith(top: 0),
                              child: StaggeredGrid.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: List.generate(
                                  snapShot.data!.length,
                                  (index) => Card(
                                    elevation: 5,
                                    child: InkWell(
                                      onTap: () => page(
                                        context: context,
                                        page: RecipeDetails(
                                            recipe: snapShot.data![index]),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 2,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                top: Radius.circular(12.5),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    snapShot.data![index].image,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(
                                              snapShot.data![index].title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 32),
                                    child: Text(
                                      'He hasn\'t posted any recipes yet',
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
                        } else if (snapShot.hasError) {
                          return Center(child: Text(snapShot.error.toString()));
                        } else if (snapShot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (userSnapshot.hasError) {
            return Center(child: Text(userSnapshot.error.toString()));
          } else if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container();
          }
        },
      );

  Widget data({required String title, required int data}) {
    String dataString;

    switch (data) {
      case >= 1000000000:
        dataString = '${(data / 1000000).toStringAsFixed(2)}M';
        break;
      case >= 1000000:
        dataString = '${(data / 1000000).toStringAsFixed(2)}M';
        break;
      case >= 1000:
        dataString = '${(data / 1000).toStringAsFixed(2)}K';
        break;
      default:
        dataString = data.toString();
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          Text(
            dataString,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  final UserModel user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  String? image;

  @override
  void initState() {
    super.initState();

    setState(() {
      name = TextEditingController(text: widget.user.name);
      email = TextEditingController(text: widget.user.email);
      image = widget.user.image;
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                    shape: BoxShape.circle,
                    color: Colors.transparent.withOpacity(0.5),
                    image: image != null
                        ? DecorationImage(
                            image: NetworkImage(image!),
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.darken,
                            ),
                          )
                        : null,
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
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.camera_alt),
                  ),
                ),

                // Name
                Text(
                  'Name',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: name,
                  keyboardType: TextInputType.emailAddress,
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

                // Email
                Text(
                  'Email',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '* required';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return '* enter a valid email';
                    } else {
                      return null;
                    }
                  },
                  onFieldSubmitted: (value) => validator(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => validator(),
            child: const Text('update'),
          ),
        ],
      );

  void validator() {
    if (formKey.currentState!.validate()) {
      AuthenticationController.update(
        context: context,
        user: widget.user.copyWith(
          newName: name.text,
          newEmail: email.text,
          newImage: image,
        ),
      );
    }
  }
}
