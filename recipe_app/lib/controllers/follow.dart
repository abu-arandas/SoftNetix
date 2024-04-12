import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowedController {
  static CollectionReference<Map<String, dynamic>> followedCollection =
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('followed');

  static Stream<List<String>> saved() => followedCollection.snapshots().map(
        (query) => query.docs.map((item) => item.id).toList(),
      );

  static Widget iconButton({required String id}) => StreamBuilder(
        stream: saved(),
        builder: (context, snapshot) => IconButton(
          onPressed: () {
            if (snapshot.hasData && snapshot.data!.contains(id)) {
              followedCollection.doc(id).delete();
            } else {
              followedCollection.doc(id).set({});
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

  static Widget elevatedButton(
          {required BuildContext context, required String id}) =>
      StreamBuilder(
        stream: saved(),
        builder: (context, snapshot) => ElevatedButton(
          onPressed: () {
            if (snapshot.hasData && snapshot.data!.contains(id)) {
              followedCollection.doc(id).delete();
            } else {
              followedCollection.doc(id).set({});
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: snapshot.hasData && snapshot.data!.contains(id)
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            snapshot.hasData && snapshot.data!.contains(id)
                ? 'Unfollow'
                : 'Follow',
          ),
        ),
      );
}
