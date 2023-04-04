import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/produtos.dart';
import 'package:flutter_firebase/service/auth_service.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_maps/google_maps.dart' hide Icon;
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

class ProdutoDetails extends StatefulWidget {
  const ProdutoDetails({Key? key}) : super(key: key);

  @override
  State<ProdutoDetails> createState() => _ProdutoDetailsState();
}

class _ProdutoDetailsState extends State<ProdutoDetails> {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('products');

  Widget getGoogleMaps() {
    String htmlId = "7";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final myLatlng = LatLng(-23.65703399470895, -46.61457628696758);

      final mapOptions = MapOptions()
        ..zoom = 8
        ..center = myLatlng;

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem, mapOptions);

      Marker(
        MarkerOptions()
          ..position = myLatlng
          ..map = map
          ..title = 'Hello World!',
      );

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }

  Future<void> _confirmBuyProduct() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: const EdgeInsets.only(bottom: 10, right: 20),
          title: const Text('Alerta!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Você deseja realmente realizar essa compra?',
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
              child: const Text('Confirmar',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.green)),
              onPressed: () {
                Get.to(() => const Produto());
                AuthService.to
                    .showSnackSuccess("Sua compra foi realizada com êxito!");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[200],
        iconTheme: const IconThemeData(color: Colors.black45),
        title: Text(
          'Detalhes da compra',
          style: GoogleFonts.ubuntu(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder(
          stream: collection.snapshots(includeMetadataChanges: true),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Aguarde...',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView(
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 24,
                        bottom: 12,
                        left: 24,
                        right: 24,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Sua localização:',
                            style: GoogleFonts.ubuntu(
                              textStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 0.7,
                      )),
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: getGoogleMaps(),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 12,
                            bottom: 12,
                            left: 24,
                            right: 24,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Produtos:',
                                style: GoogleFonts.ubuntu(
                                  textStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, top: 8, right: 20, bottom: 10),
                          height: 100,
                          width: 500,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(2, 2), //
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 0, bottom: 10, right: 20),
                                child: ClipOval(
                                  child: Material(
                                    child: Image.asset(
                                      snapshot.data!.docs[1]['filename'],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        top: 14,
                                        left: 0,
                                        bottom: 8,
                                      ),
                                      child: Text(
                                        '${snapshot.data!.docs[1]['title']}',
                                        style: GoogleFonts.ubuntu(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 0, left: 0),
                                      child: Text(
                                        'Descrição:',
                                        style: GoogleFonts.ubuntu(
                                          textStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        top: 8,
                                        left: 0,
                                      ),
                                      child: Text(
                                        '${snapshot.data!.docs[1]['description']}',
                                        style: GoogleFonts.ubuntu(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 24, right: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Preço: ',
                                            style: GoogleFonts.ubuntu(
                                              textStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 4, top: 10, right: 3),
                                            child: Text(
                                              NumberFormat.compactCurrency(
                                                locale: 'pt-BR',
                                                symbol: "R\$ ",
                                                decimalDigits: 2,
                                              ).format(snapshot.data!.docs[1]
                                                  ['price']),
                                              style: GoogleFonts.ubuntu(
                                                textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 500,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 70, left: 28, right: 28, bottom: 55),
                            child: ElevatedButton(
                              onPressed: _confirmBuyProduct,
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.amber[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          size: 16,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            "Realizar  compra",
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
