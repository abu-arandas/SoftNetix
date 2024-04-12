import 'package:flutter/material.dart';

page({
  required BuildContext context,
  required Widget page,
  bool remove = false,
}) {
  PageRouteBuilder pageRouteBuilder = PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      position: Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
      child: child,
    ),
  );

  if (remove) {
    Navigator.of(context).pushAndRemoveUntil(
      pageRouteBuilder,
      (Route<dynamic> route) => false,
    );
  } else {
    Navigator.of(context).push(pageRouteBuilder);
  }
}
