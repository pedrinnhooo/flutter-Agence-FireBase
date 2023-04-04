import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/login.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final email = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isLogin = true.obs;
  final nameUser = TextEditingController();
  final photoUser = TextEditingController();
  final senha = TextEditingController();

  registrar() async {
    try {
      AuthService.to.userIsAuthenticated = true.obs;
      await AuthService.to.createUser(email.text, senha.text, nameUser.text);
      AuthService.to.userIsAuthenticated = false.obs;
    } catch (e) {
      AuthService.to.userIsAuthenticated = false.obs;
      AuthService.to.showSnackError("Não foi possível registrar o usuário!");
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
                          "Cadastro",
                          style: GoogleFonts.sourceSansPro(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
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
                          "Faça o cadastro para entrar na sua conta",
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
                                controller: nameUser,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                      color: Colors.black45,
                                      size: 18,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.amber,
                                        width: 0.7,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.black45, width: 1),
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    label: const Text("Usuário"),
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
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 40, left: 28, right: 28, bottom: 55),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (isLogin.value) {
                                      registrar();
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
                                        "CADASTRAR",
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
                          SizedBox(
                            height: 40,
                            child: Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () => Get.to(() => const Login()),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Já possui uma conta? ',
                                      ),
                                      TextSpan(
                                          text: ' Entrar',
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
