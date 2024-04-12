import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/constants.dart';

import '/models/user.dart';

import '/screens/home/home_screen.dart';
import '/screens/authentication/login.dart';

class AuthenticationController {
  static CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');

  static Stream<List<UserModel>> users() => usersCollection.snapshots().map(
        (query) => query.docs.map((item) => UserModel.fromJson(item)).toList(),
      );

  static Stream<UserModel> user(String id) => usersCollection
      .doc(id)
      .snapshots()
      .map((query) => UserModel.fromJson(query));

  static void login({
    required BuildContext context,
    required String email,
    required String password,
  }) {
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => page(
                context: context,
                page: const HomeScreen(),
                remove: true,
              ))
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Welcome Back')),
              ));
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    }
  }

  static void register({
    required BuildContext context,
    required UserModel user,
  }) {
    try {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password!)
          .then((value) => AuthenticationController.usersCollection
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set(user.toJson()))
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Welcome Back')),
              ))
          .then((value) => page(
                context: context,
                page: const HomeScreen(),
                remove: true,
              ))
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Welcome to Our App')),
              ));
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    }
  }

  static void update({
    required BuildContext context,
    required UserModel user,
  }) {
    try {
      AuthenticationController.usersCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(user.toJson())
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

  static void logout(context) {
    try {
      FirebaseAuth.instance
          .signOut()
          .then((value) => page(
                context: context,
                page: const Login(),
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
}
