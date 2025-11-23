import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views lib/home_screen.dart';

void main() async {
  //Flutter ready
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Hourse Tracker',
      theme: ThemeData(
        // collorScheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 48, 37, 62),
        ),
        useMaterial3: true,
      ),

      home: const HomeScreen(),
    );
  }
}
