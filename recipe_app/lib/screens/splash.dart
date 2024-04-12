import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/constants.dart';

import 'authentication/login.dart';
import 'home/home_screen.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          padding: const EdgeInsets.all(64),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
            image: DecorationImage(
              image: const AssetImage('assets/images/splash.png'),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken),
            ),
          ),
          child: Column(
            children: [
              Image.asset('assets/images/logo.png'),
              const Spacer(),
              Text(
                'Get Cooking',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Simple way to find Tasty Recipe',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(height: 32),
              StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) => ElevatedButton(
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: 'e00arandas@gmail.com',
                        password: 'ehab123',
                      );

                      page(
                        context: context,
                        page: snapshot.hasData
                            ? const HomeScreen()
                            : const Login(),
                        remove: true,
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                  ),
                  child: const Text('Start Cooking'),
                ),
              ),
            ],
          ),
        ),
      );
}
