import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../pages/produtos.dart';
import '../pages/login.dart';
import '../service/auth_service.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => AuthCheckState();
}

class AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AuthService.to.userIsAuthenticated.value == F
          ? const Login()
          : const Produto(),
    );
  }
}
