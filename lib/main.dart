import 'package:flutter/material.dart';
import 'config/init_configs.dart';
import 'myapp.dart';

void main() async {
  await initConfigurations();

  runApp(
    const MyApp(),
  );
}
