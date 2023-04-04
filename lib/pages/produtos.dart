import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/widgets/drawer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'produto_details.dart';

class Produto extends StatefulWidget {
  const Produto({Key? key}) : super(key: key);

  @override
  State<Produto> createState() => _FireStorePageState();
}

class _FireStorePageState extends State<Produto> {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[200],
        iconTheme: const IconThemeData(color: Colors.black45),
        title: Text(
          'Produtos',
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
      drawer: drawer(context),
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

              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 230,
                    mainAxisExtent: 230,
                    crossAxisSpacing: 2,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => const ProdutoDetails());
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 10, top: 20, right: 10, bottom: 10),
                              height: double.infinity,
                              width: double.infinity,
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: ClipOval(
                                      child: Material(
                                        child: Image.asset(
                                            snapshot.data!.docs[index]
                                                ['filename'],
                                            width: 80,
                                            height: 70,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 14, left: 10),
                                      child: Center(
                                        child: Text(
                                          '${snapshot.data!.docs[index]['title']}',
                                          style: GoogleFonts.ubuntu(
                                            textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 10),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Preço: ',
                                              style: GoogleFonts.ubuntu(
                                                textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                NumberFormat.compactCurrency(
                                                  locale: 'pt-BR',
                                                  symbol: "R\$ ",
                                                  decimalDigits: 2,
                                                ).format(snapshot.data!
                                                    .docs[index]['price']),
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
                                  ),
                                ],
                              ),
                            ),
                          )),
                    );
                  });
            }),
      ),
    );
  }
}
