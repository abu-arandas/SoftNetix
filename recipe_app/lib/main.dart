import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screens/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Recipe App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF129575),
            background: const Color(0xFFF8F8F8),
          ),
          appBarTheme: const AppBarTheme(
            toolbarHeight: 75,
            backgroundColor: Color(0xFF129575),
            titleTextStyle: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.all(16),
            labelStyle: const TextStyle(fontSize: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            errorBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
          buttonTheme: const ButtonThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            buttonColor: Color(0xFF129575),
          ),
          textButtonTheme: const TextButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStatePropertyAll(Colors.transparent),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.hovered) ||
                        states.contains(MaterialState.pressed)
                    ? Colors.white
                    : const Color(0xFF129575),
              ),
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.hovered) ||
                        states.contains(MaterialState.pressed)
                    ? const Color(0xFF129575)
                    : Colors.white,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.hovered) ||
                        states.contains(MaterialState.pressed)
                    ? Colors.white
                    : const Color(0xFF129575),
              ),
              side: MaterialStateProperty.resolveWith(
                (states) => BorderSide(
                  color: states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.hovered) ||
                          states.contains(MaterialState.pressed)
                      ? Colors.white
                      : const Color(0xFF129575),
                ),
              ),
            ),
          ),
        ),
        home: OrientationBuilder(
          builder: (context, orientation) => const Splash(),
        ),
      );
}
