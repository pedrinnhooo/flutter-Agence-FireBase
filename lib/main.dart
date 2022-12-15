import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/pages/fireBaseFireStore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        debugShowCheckedModeBanner: false,
        home: const FireBaseFireStore());
  }
}
