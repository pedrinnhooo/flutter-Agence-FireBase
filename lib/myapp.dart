import 'package:flutter/material.dart';
import 'package:flutter_firebase/widgets/authCheck.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthCheck(),
    );
  }
}
