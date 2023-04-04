import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import '../service/auth_service.dart';
import 'firebase_options.dart';

initConfigurations() async {
  debugPrint("App Starting: ${DateTime.now()}");

  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  ]);

  if (kIsWeb) {
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "476679187918612",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }

  Get.lazyPut<AuthService>(() => AuthService(FirebaseAuth.instance));

  debugPrint("App Loaded: ${DateTime.now()}");
}
