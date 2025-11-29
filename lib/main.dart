import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:work_hours_tracker/views/settings_screen.dart';
import 'firebase_options.dart';
import 'views/home_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/firestore.dart';
import 'BLoC/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<WorkLogBloc>(
          create: (context) => WorkLogBloc(firestoreService),
        ),
      ],
      child: MaterialApp(
        title: 'Work Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 48, 37, 62),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
