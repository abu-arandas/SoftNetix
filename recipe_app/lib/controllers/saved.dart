import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedController {
  static CollectionReference<Map<String, dynamic>> savedCollection =
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('saved');

  static Stream<List<String>> saved() => savedCollection.snapshots().map(
        (query) => query.docs.map((item) => item.id).toList(),
      );

  static Widget button({required String id}) => StreamBuilder(
        stream: saved(),
        builder: (context, snapshot) => IconButton(
          onPressed: () {
            if (snapshot.hasData && snapshot.data!.contains(id)) {
              savedCollection.doc(id).delete();
            } else {
              savedCollection.doc(id).set({});
            }
          },
          icon: Icon(
            snapshot.hasData && snapshot.data!.contains(id)
                ? Icons.bookmark
                : Icons.bookmark_border,
            color: snapshot.hasData
                ? snapshot.data!.contains(id)
                    ? Colors.amber
                    : null
                : null,
          ),
        ),
      );
}
