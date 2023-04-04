import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/auth_google.dart';
import '../service/auth_service.dart';

@override
Widget drawer(BuildContext context) {
  // ignore: no_leading_underscores_for_local_identifiers, unused_local_variable
  bool _isSigningOut = false;
  // ignore: no_leading_underscores_for_local_identifiers
  Future<void> _exitAppAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: const EdgeInsets.only(bottom: 10, right: 20),
          title: const Text('Sair',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Você deseja realmente sair de sua conta?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.grey)),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: const Text('Sair',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.red)),
              onPressed: () async {
                if (_isSigningOut = true) {
                  await AuthGoogle.signOut(context: context);
                  _isSigningOut = false;
                }
              },
            ),
          ],
        );
      },
    );
  }

  return Drawer(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      verticalDirection: VerticalDirection.down,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 60, left: 10),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 15, left: 15),
                child: ClipOval(
                  child: Material(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 8),
                    child: Container(
                      width: 150,
                      height: 28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent),
                      child: Center(
                        child: Text(
                          "Bem-vindo !",
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      width: 170,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.amber[200]),
                      child: Center(
                        child: Text(
                          "${AuthService.to.user?.displayName}",
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 20),
                    child: Text(
                      "${AuthService.to.user?.email}",
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 48, left: 28),
              child: Text(
                "Perfil",
                style: GoogleFonts.ubuntu(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 28,
            right: 28,
          ),
          child: Container(
            color: Colors.grey[600],
            height: 0.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 58,
          ),
          child: Row(
            children: [
              Image.asset(
                "profile.png",
                width: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Perfil",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 15,
            left: 58,
          ),
          child: Row(
            children: [
              Image.asset(
                "wallet.png",
                width: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Meus produtos",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 88, left: 28),
              child: Text(
                "Configurações",
                style: GoogleFonts.ubuntu(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 28,
            right: 28,
          ),
          child: Container(
            color: Colors.grey[600],
            height: 0.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 58,
          ),
          child: Row(
            children: [
              Image.asset(
                "about.png",
                width: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Configurações",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 28),
              child: Text(
                "Sair",
                style: GoogleFonts.ubuntu(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 28,
            right: 28,
          ),
          child: Container(
            color: Colors.grey[600],
            height: 0.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 58,
          ),
          child: InkWell(
            onTap: _exitAppAlertDialog,
            child: Row(
              children: const [
                Icon(
                  Icons.logout_rounded,
                  size: 16,
                  color: Colors.red,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
