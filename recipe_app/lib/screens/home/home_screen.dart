import 'package:flutter/material.dart';
import 'package:recipe_app/constants.dart';

import 'pages/dashboard.dart';
import 'pages/saved.dart';
import 'recipe/add.dart';
import 'pages/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPage = 0;

  List<Widget> pages = const [
    Dashboard(),
    Saved(),
    AddRecipe(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        // Body
        body: pages[selectedPage],

        // Bottom Nav Bar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedPage,
          showSelectedLabels: false,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          onTap: (value) {
            if (value != 3) {
              setState(() => selectedPage = value);
            } else {
              page(context: context, page: const Profile());
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ],
        ),
      );
}
/*  */