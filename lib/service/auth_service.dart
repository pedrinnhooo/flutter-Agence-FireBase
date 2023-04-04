import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/produtos.dart';
import '../pages/login.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> _firebaseUser;
  var userIsAuthenticated = false.obs;

  AuthService(FirebaseAuth instance);

  @override
  void onInit() {
    super.onInit();

    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.authStateChanges());

    ever(_firebaseUser, (User? user) {
      if (user != null) {
        userIsAuthenticated.value = true;
      } else {
        userIsAuthenticated.value = false;
      }
    });
  }

  User? get user => _firebaseUser.value;
  static AuthService get to => Get.find<AuthService>();

  createUser(String email, String password, String nameUser) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await user?.updateDisplayName(nameUser);
      Get.to(() => const Produto());
      showSnackSuccess('Usuário registrado com sucesso!');
      await user?.reload();
    } catch (e) {
      showSnackError('E-mail ja registrado!');
    }
  }

  login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.to(() => const Produto());
      showSnackSuccess('Login realizado com sucesso!');
    } catch (e) {
      showSnackError('E-mail ou senha incorreta!');
    }
  }

  logout() async {
    try {
      await _auth.signOut();
      Get.to(() => const Login());
      showSnackAlert('Você saiu do app!');
    } catch (e) {
      showSnackError('Erro ao sair!');
    }
  }

  // SnackBar Top.Align

  showSnackSuccess(String erro) {
    Get.snackbar(
      "Sucesso",
      erro,
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
      ),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 24,
      margin: const EdgeInsets.all(24),
      snackPosition: SnackPosition.TOP,
    );
  }

  showSnackError(String erro) {
    Get.snackbar(
      "Erro",
      erro,
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Colors.white,
      ),
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 24,
      margin: const EdgeInsets.all(24),
      snackPosition: SnackPosition.TOP,
    );
  }

  showSnackAlert(String erro) {
    Get.snackbar(
      "Alerta",
      erro,
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Colors.white,
      ),
      backgroundColor: Colors.black45,
      colorText: Colors.white,
      borderRadius: 24,
      margin: const EdgeInsets.all(24),
      snackPosition: SnackPosition.TOP,
    );
  }
}
