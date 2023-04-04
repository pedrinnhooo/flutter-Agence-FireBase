import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_firebase/pages/produtos.dart';
import 'package:flutter_firebase/pages/signUp.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../service/auth_service.dart';
import '../service/auth_google.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final senha = TextEditingController();

  var isLogin = true.obs;
  bool _isSigningIn = false;
  bool _isLoggedIn = false;
  Map _userObj = {};

  login() async {
    try {
      AuthService.to.userIsAuthenticated = true.obs;
      await AuthService.to.login(email.text, senha.text);
      AuthService.to.userIsAuthenticated = false.obs;
    } catch (e) {
      AuthService.to.userIsAuthenticated = false.obs;
      AuthService.to.showSnackError("Erro ao realizar o login!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => AuthService.to.userIsAuthenticated.value
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: 500,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100, left: 34),
                        child: Text(
                          "Bem-vindo,",
                          style: GoogleFonts.sourceSansPro(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24, left: 34),
                        child: Text(
                          "Realize o login e\naproveite nosso app",
                          style: GoogleFonts.sourceSansPro(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60, left: 30),
                        child: Text(
                          "Faça login na sua conta",
                          style: GoogleFonts.ubuntu(
                            textStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 500,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 28, right: 28, bottom: 5),
                              child: TextFormField(
                                controller: email,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: Colors.black45,
                                      size: 18,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.amber, width: 0.7),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.black45, width: 1),
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    label: const Text("Email"),
                                    labelStyle: GoogleFonts.sourceSansPro(
                                      textStyle: const TextStyle(
                                        color: Colors.black45,
                                        fontSize: 12,
                                      ),
                                    )),
                                style: GoogleFonts.sourceSansPro(
                                  textStyle: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe o email corretamente!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 500,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, left: 28, right: 28, bottom: 5),
                              child: TextFormField(
                                controller: senha,
                                obscureText: true,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.key,
                                      color: Colors.black45,
                                      size: 18,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.amber, width: 0.7),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.black45, width: 1),
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    label: const Text("Senha"),
                                    labelStyle: GoogleFonts.sourceSansPro(
                                      textStyle: const TextStyle(
                                        color: Colors.black45,
                                        fontSize: 12,
                                      ),
                                    )),
                                style: GoogleFonts.sourceSansPro(
                                  textStyle: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informa sua senha!';
                                  } else if (value.length < 6) {
                                    return 'Sua senha deve ter no mínimo 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 500,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 23),
                                child: Column(
                                  children: [
                                    Text(
                                      'Esqueceu a senha?',
                                      style: GoogleFonts.sourceSansPro(
                                        textStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 500,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 40, left: 28, right: 28, bottom: 55),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (isLogin.value) {
                                      login();
                                    }
                                  }
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.amber[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        "LOGIN",
                                        style: GoogleFonts.sourceSansPro(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text(
                                  ' ou entre com ',
                                  style: GoogleFonts.ubuntu(
                                    textStyle: const TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            width: 500,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 120, right: 120, bottom: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        _isSigningIn = true;
                                      });
                                      User? user =
                                          await AuthGoogle.signInWithGoogle(
                                              context: context);

                                      setState(() {
                                        _isSigningIn = false;
                                      });

                                      if (user != null) {
                                        Get.to(() => const Produto());
                                      }
                                    },
                                    child: Image.asset(
                                      "google.png",
                                      width: 22,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      FacebookAuth.instance.login(
                                        permissions: [
                                          "public_profile",
                                          "email",
                                        ],
                                      ).then((value) {
                                        FacebookAuth.instance
                                            .getUserData()
                                            .then((userData) {
                                          setState(() {
                                            _isLoggedIn = true;
                                            _userObj = userData;
                                            //Get.to(() => const Produto());
                                          });
                                        });
                                      });
                                    },
                                    child: Image.asset(
                                      "facebook.png",
                                      width: 26,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () => Get.to(() => const SignUp()),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Ainda não possui uma conta? ',
                                      ),
                                      TextSpan(
                                          text: '  Cadastre-se',
                                          style:
                                              TextStyle(color: Colors.black87)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
    );
  }
}
