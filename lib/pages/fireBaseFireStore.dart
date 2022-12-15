import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/formatterText/formatter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mask_input_formatter/mask_input_formatter.dart';

class FireBaseFireStore extends StatefulWidget {
  const FireBaseFireStore({Key? key}) : super(key: key);

  @override
  State<FireBaseFireStore> createState() => _FireStorePageState();
}

class _FireStorePageState extends State<FireBaseFireStore> {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('products');

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _edtTitleController = TextEditingController();
  final TextEditingController _edtTypeController = TextEditingController();
  final TextEditingController _edtDescriptionController =
      TextEditingController();
  final TextEditingController _edtPriceController = TextEditingController();
  final TextEditingController _edtRatingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[200],
        title: Center(
          child: Image.asset(
            'imgHome.png',
            width: 200,
          ),
        ),
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
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(strokeWidth: 7),
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Aguarde...',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 30, bottom: 10, left: 15, right: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.amber,
                                style: BorderStyle.solid,
                                width: 1)),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 15),
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                    strokeAlign: StrokeAlign.inside,
                                    style: BorderStyle.solid),
                              ),
                              child: Image.asset(
                                  snapshot.data!.docs[index]['filename'],
                                  width: 100,
                                  fit: BoxFit.cover),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          '${snapshot.data!.docs[index]['title']}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'type: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            "${snapshot.data!.docs[index]['type']}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _edtTitleController.text = snapshot
                                              .data!.docs[index]['title'];
                                          _edtTypeController.text = snapshot
                                              .data!.docs[index]['type'];
                                          _edtDescriptionController.text =
                                              snapshot.data!.docs[index]
                                                  ['description'];
                                          _edtPriceController.text =
                                              "${snapshot.data!.docs[index]['price']}";
                                          _edtRatingController.text =
                                              "${snapshot.data!.docs[index]['rating']}";

                                          productDialog(
                                              snapshot.data!.docs[index]);
                                        },
                                        hoverColor: Colors.amber,
                                        child: const Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                  const Text(
                                    '\ndescription:',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    '${snapshot.data!.docs[index]['description']}',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 5, right: 20),
                                        child: Transform.scale(
                                          scale: 0.8,
                                          child: RatingBar.builder(
                                            initialRating: (snapshot.data!
                                                    .docs[index]['rating'])
                                                .toDouble(),
                                            minRating: 0,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ),
                                      ),
                                      // ignore: prefer_interpolation_to_compose_strings
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "\n${NumberFormat.compactCurrency(
                                            locale: 'en-US',
                                            symbol: "U\$ ",
                                            decimalDigits: 2,
                                          ).format(snapshot.data!.docs[index]['price'])}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'rating: ${snapshot.data!.docs[index]['rating']}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }),
      ),
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF49b1e0),
        onPressed: () {
          saveAllJson();
        },
        child: const Icon(Icons.upload),
      ), */
    );
  }

  void productDialog(QueryDocumentSnapshot<Object?> object) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 24, bottom: 35, right: 24, left: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Editar Produto",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              "x",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 4),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: 'Title '),
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _edtTitleController,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9]").hasMatch(value)) {
                          return 'Fill in the title field!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Type in your title",
                          fillColor: Colors.white70),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 8, left: 4),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: 'Type '),
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _edtTypeController,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9]").hasMatch(value)) {
                          return 'Fill in the type field!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Type in your type",
                          fillColor: Colors.white70),
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 8, left: 4),
                          child: Text(
                            "Description",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                        controller: _edtDescriptionController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Type in your description",
                            fillColor: Colors.white70)),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 8, left: 4),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: 'Price '),
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                        controller: _edtPriceController,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r"^[0-9]").hasMatch(value)) {
                            return 'Fill in the price field!';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          DecimalFormatter()
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Type in your price",
                            fillColor: Colors.white70)),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 8, left: 4),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: 'Rating '),
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                        controller: _edtRatingController,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r"^[0-9]").hasMatch(value)) {
                            return 'Fill in the rating field!';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          MaskInputFormatter(mask: "#.#"),
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Type in your rating",
                            fillColor: Colors.white70)),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: const Text("Excluir Produto",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                      content: const Text(
                                        "Deseja realmente excluir este produto ?",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15),
                                      ),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: InkWell(
                                            onTap: () => Navigator.pop(context),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: const Text("Cancelar",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 13))),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: InkWell(
                                            onTap: () async {
                                              await object.reference
                                                  .delete()
                                                  .then((value) =>
                                                      Navigator.pop(context))
                                                  .catchError((error) {
                                                print(error);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: const Text("Excluir",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 13))),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: const Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final isValid = _formKey.currentState!.validate();
                              if (isValid) {
                                object;
                                await object.reference
                                    .set({
                                      "title": _edtTitleController.text,
                                      "type": _edtTypeController.text,
                                      "description":
                                          _edtDescriptionController.text,
                                      "filename": object['filename'],
                                      "height": object['height'],
                                      "width": object['width'],
                                      "price": double.parse(
                                          _edtPriceController.text),
                                      "rating": double.parse(
                                          _edtRatingController.text)
                                    })
                                    .then((_) => Navigator.pop(context))
                                    .catchError((error) {
                                      print(error);
                                    });
                              }
                              _formKey.currentState!.save();
                            },
                            child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.amber,
                                        style: BorderStyle.solid,
                                        width: 1)),
                                child: const Text("Confirmar edição")),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  /* void saveAllJson() {
    const List<Map<String, dynamic>> jsonString = [
      {
        "title": "Brown eggs",
        "type": "dairy",
        "description": "Raw organic brown eggs in a basket",
        "filename": "0.jpg",
        "height": 600,
        "width": 400,
        "price": 28.1,
        "rating": 4
      },
      {
        "title": "Sweet fresh stawberry",
        "type": "fruit",
        "description": "Sweet fresh stawberry on the wooden table",
        "filename": "1.jpg",
        "height": 450,
        "width": 299,
        "price": 29.45,
        "rating": 4
      },
      {
        "title": "Asparagus",
        "type": "vegetable",
        "description": "Asparagus with ham on the wooden table",
        "filename": "2.jpg",
        "height": 450,
        "width": 299,
        "price": 18.95,
        "rating": 3
      },
      {
        "title": "Green smoothie",
        "type": "dairy",
        "description":
            "Glass of green smoothie with quail egg's yolk, served with cocktail tube, green apple and baby spinach leaves over tin surface.",
        "filename": "3.jpg",
        "height": 600,
        "width": 399,
        "price": 17.68,
        "rating": 4
      },
      {
        "title": "Raw legums",
        "type": "vegetable",
        "description": "Raw legums on the wooden table",
        "filename": "4.jpg",
        "height": 450,
        "width": 299,
        "price": 17.11,
        "rating": 2
      },
      {
        "title": "Baking cake",
        "type": "dairy",
        "description":
            "Baking cake in rural kitchen - dough  recipe ingredients (eggs, flour, sugar) on vintage wooden table from above.",
        "filename": "5.jpg",
        "height": 450,
        "width": 675,
        "price": 11.14,
        "rating": 4
      },
      {
        "title": "Pesto with basil",
        "type": "vegetable",
        "description": "Italian traditional pesto with basil, chesse and oil",
        "filename": "6.jpg",
        "height": 450,
        "width": 299,
        "price": 18.19,
        "rating": 2
      },
      {
        "title": "Hazelnut in black ceramic bowl",
        "type": "vegetable",
        "description":
            "Hazelnut in black ceramic bowl on old wooden background. forest wealth. rustic style. selective focus",
        "filename": "7.jpg",
        "height": 450,
        "width": 301,
        "price": 27.35,
        "rating": 0
      },
      {
        "title": "Fresh stawberry",
        "type": "fruit",
        "description": "Sweet fresh stawberry on the wooden table",
        "filename": "8.jpg",
        "height": 600,
        "width": 399,
        "price": 28.59,
        "rating": 4
      },
      {
        "title": "Lemon and salt",
        "type": "fruit",
        "description": "Rosemary, lemon and salt on the table",
        "filename": "9.jpg",
        "height": 450,
        "width": 299,
        "price": 15.79,
        "rating": 5
      },
      {
        "title": "Homemade bread",
        "type": "bakery",
        "description": "Homemade bread",
        "filename": "10.jpg",
        "height": 450,
        "width": 301,
        "price": 17.48,
        "rating": 3
      },
      {
        "title": "Legums",
        "type": "vegetable",
        "description": "Cooked legums on the wooden table",
        "filename": "11.jpg",
        "height": 600,
        "width": 399,
        "price": 14.77,
        "rating": 0
      },
      {
        "title": "Fresh tomato",
        "type": "vegetable",
        "description": "Fresh tomato juice with basil",
        "filename": "12.jpg",
        "height": 600,
        "width": 903,
        "price": 16.3,
        "rating": 2
      },
      {
        "title": "Healthy breakfast",
        "type": "fruit",
        "description":
            "Healthy breakfast set. rice cereal or porridge with berries and honey over rustic wood background",
        "filename": "13.jpg",
        "height": 450,
        "width": 350,
        "price": 13.02,
        "rating": 2
      },
      {
        "title": "Green beans",
        "type": "vegetable",
        "description": "Raw organic green beans ready to eat",
        "filename": "14.jpg",
        "height": 450,
        "width": 300,
        "price": 28.79,
        "rating": 1
      },
      {
        "title": "Baked stuffed portabello mushrooms",
        "type": "bakery",
        "description":
            "Homemade baked stuffed portabello mushrooms with spinach and cheese",
        "filename": "15.jpg",
        "height": 600,
        "width": 400,
        "price": 20.31,
        "rating": 1
      },
      {
        "title": "Strawberry jelly",
        "type": "fruit",
        "description": "Homemade organic strawberry jelly in a jar",
        "filename": "16.jpg",
        "height": 400,
        "width": 600,
        "price": 14.18,
        "rating": 1
      },
      {
        "title": "Pears juice",
        "type": "fruit",
        "description": "Fresh pears juice on the wooden table",
        "filename": "17.jpg",
        "height": 600,
        "width": 398,
        "price": 19.49,
        "rating": 4
      },
      {
        "title": "Fresh pears",
        "type": "fruit",
        "description": "Sweet fresh pears on the wooden table",
        "filename": "18.jpg",
        "height": 600,
        "width": 398,
        "price": 15.12,
        "rating": 5
      },
      {
        "title": "Caprese salad",
        "type": "vegetable",
        "description":
            "Homemade healthy caprese salad with tomato mozzarella and basil",
        "filename": "19.jpg",
        "height": 400,
        "width": 600,
        "price": 16.76,
        "rating": 5
      },
      {
        "title": "Oranges",
        "type": "fruit",
        "description":
            "Orange popsicle ice cream bars made from fresh oranges.  a refreshing summer treat.",
        "filename": "20.jpg",
        "height": 450,
        "width": 274,
        "price": 21.48,
        "rating": 4
      },
      {
        "title": "Vegan food",
        "type": "vegetable",
        "description": "Concept of vegan food",
        "filename": "21.jpg",
        "height": 450,
        "width": 299,
        "price": 29.66,
        "rating": 4
      },
      {
        "title": "Breakfast with muesli",
        "type": "dairy",
        "description": "Concept of healthy breakfast with muesli",
        "filename": "22.jpg",
        "height": 450,
        "width": 299,
        "price": 22.7,
        "rating": 2
      },
      {
        "title": "Honey",
        "type": "bakery",
        "description": "Honey and honeycell on the table",
        "filename": "23.jpg",
        "height": 450,
        "width": 299,
        "price": 17.01,
        "rating": 2
      },
      {
        "title": "Breakfast with cottage",
        "type": "fruit",
        "description": "Healthy breakfast with cottage cheese and strawberry",
        "filename": "24.jpg",
        "height": 600,
        "width": 398,
        "price": 14.05,
        "rating": 1
      },
      {
        "title": "Strawberry smoothie",
        "type": "fruit",
        "description":
            "Glass of red strawberry smoothie with chia seeds, served with retro cocktail tube, fresh mint and strawberries over dark background",
        "filename": "25.jpg",
        "height": 600,
        "width": 400,
        "price": 28.86,
        "rating": 2
      },
      {
        "title": "Strawberry and mint",
        "type": "fruit",
        "description": "Homemade muesli with strawberry and mint",
        "filename": "26.jpg",
        "height": 450,
        "width": 299,
        "price": 26.21,
        "rating": 4
      },
      {
        "title": "Ricotta",
        "type": "dairy",
        "description": "Ricotta with berry and mint",
        "filename": "27.jpg",
        "height": 600,
        "width": 398,
        "price": 27.81,
        "rating": 5
      },
      {
        "title": "Cuban sandwiche",
        "type": "bakery",
        "description":
            "Homemade traditional cuban sandwiches with ham pork and cheese",
        "filename": "28.jpg",
        "height": 450,
        "width": 300,
        "price": 18.5,
        "rating": 4
      },
      {
        "title": "Granola",
        "type": "dairy",
        "description":
            "Glass jar with homemade granola and yogurt with nuts, raspberries and blackberries on wooden cutting board over white textile in day light",
        "filename": "29.jpg",
        "height": 450,
        "width": 300,
        "price": 29.97,
        "rating": 3
      },
      {
        "title": "Smoothie with chia seeds",
        "type": "fruit",
        "description":
            "Glass of red strawberry smoothie with chia seeds, served with retro cocktail tube, fresh mint and strawberries over wooden table",
        "filename": "30.jpg",
        "height": 600,
        "width": 900,
        "price": 25.26,
        "rating": 5
      },
      {
        "title": "Yogurt",
        "type": "dairy",
        "description": "Homemade yogurt with raspberry and mint",
        "filename": "31.jpg",
        "height": 450,
        "width": 299,
        "price": 27.61,
        "rating": 4
      },
      {
        "title": "Sandwich with salad",
        "type": "vegetable",
        "description": "Vegan sandwich with salad, tomato and radish",
        "filename": "32.jpg",
        "height": 600,
        "width": 398,
        "price": 22.48,
        "rating": 5
      },
      {
        "title": "Cherry",
        "type": "fruit",
        "description": "Cherry with sugar on old table",
        "filename": "33.jpg",
        "height": 600,
        "width": 400,
        "price": 14.35,
        "rating": 5
      },
      {
        "title": "Raw asparagus",
        "type": "vegetable",
        "description": "Raw fresh asparagus salad with cheese and dressing",
        "filename": "34.jpg",
        "height": 600,
        "width": 400,
        "price": 22.97,
        "rating": 4
      },
      {
        "title": "Corn",
        "type": "vegetable",
        "description": "Grilled corn on the cob with salt and butter",
        "filename": "35.jpg",
        "height": 450,
        "width": 300,
        "price": 13.55,
        "rating": 2
      },
      {
        "title": "Vegan",
        "type": "vegan",
        "description": "Concept of healthy vegan eating",
        "filename": "36.jpg",
        "height": 600,
        "width": 398,
        "price": 28.96,
        "rating": 5
      },
      {
        "title": "Fresh blueberries",
        "type": "fruit",
        "description":
            "Healthy breakfast. berry crumble with fresh blueberries, raspberries, strawberries, almond, walnuts, pecans, yogurt, and mint in ceramic plates over white wooden surface, top view",
        "filename": "37.jpg",
        "height": 450,
        "width": 321,
        "price": 21.01,
        "rating": 4
      },
      {
        "title": "Smashed avocado",
        "type": "fruit",
        "description":
            "Vegan sandwiches with smashed avocado, tomatoes and radish. top view",
        "filename": "38.jpg",
        "height": 450,
        "width": 450,
        "price": 25.88,
        "rating": 0
      },
      {
        "title": "Italian ciabatta",
        "type": "bakery",
        "description":
            "Italian ciabatta bread cut in slices on wooden chopping board with herbs, garlic and olives over dark grunge backdrop, top view",
        "filename": "39.jpg",
        "height": 450,
        "width": 565,
        "price": 15.18,
        "rating": 1
      },
      {
        "title": "Rustic breakfast",
        "type": "dairy",
        "description":
            "Rustic healthy breakfast set. cooked buckwheat groats with milk and honey on dark grunge backdrop. top view, copy space",
        "filename": "40.jpg",
        "height": 450,
        "width": 307,
        "price": 21.32,
        "rating": 0
      },
      {
        "title": "Sliced lemons",
        "type": "fruit",
        "description":
            "Heap of whole and sliced lemons and limes with mint in vintage metal grid box over old wooden table with turquoise wooden background. dark rustic style.",
        "filename": "41.jpg",
        "height": 600,
        "width": 900,
        "price": 27.14,
        "rating": 2
      },
      {
        "title": "Plums",
        "type": "fruit",
        "description": "Yellow and red sweet plums",
        "filename": "42.jpg",
        "height": 450,
        "width": 299,
        "price": 19.18,
        "rating": 1
      },
      {
        "title": "French fries",
        "type": "bakery",
        "description": "Homemade oven baked french fries with ketchup",
        "filename": "43.jpg",
        "height": 600,
        "width": 400,
        "price": 18.32,
        "rating": 3
      },
      {
        "title": "Strawberries",
        "type": "fruit",
        "description":
            "Healthy breakfast set. rice cereal or porridge with fresh strawberry, apricots, almond and honey over white rustic wood backdrop, top view, \u0000",
        "filename": "44.jpg",
        "height": 450,
        "width": 352,
        "price": 15.13,
        "rating": 3
      },
      {
        "title": "Ground beef meat burger",
        "type": "meat",
        "description":
            "Raw ground beef meat burger steak cutlets with seasoning on vintage wooden boards, black background",
        "filename": "45.jpg",
        "height": 450,
        "width": 675,
        "price": 11.73,
        "rating": 5
      },
      {
        "title": "Tomatoes",
        "type": "fruit",
        "description": "Organic tomatoes made with love",
        "filename": "46.jpg",
        "height": 450,
        "width": 675,
        "price": 26.03,
        "rating": 4
      },
      {
        "title": "Basil",
        "type": "vegetable",
        "description": "Concept of vegan food with basil",
        "filename": "47.jpg",
        "height": 450,
        "width": 678,
        "price": 15.19,
        "rating": 4
      },
      {
        "title": "Fruits bouquet",
        "type": "fruit",
        "description": "Abstract citrus fruits bouquet on blue background",
        "filename": "48.jpg",
        "height": 600,
        "width": 401,
        "price": 18.18,
        "rating": 1
      },
      {
        "title": "Peaches on branch",
        "type": "fruit",
        "description":
            "Peaches on branch with leaves and glasses with peach juice and limonade with ice cubes in aluminum tray over old metal table. dark rustic style. top view.",
        "filename": "49.jpg",
        "height": 600,
        "width": 400,
        "price": 25.62,
        "rating": 3
      }
    ];
    for (int i = 0; i < jsonString.length; i++) {
      collection.doc('${i + 1}').set(jsonString[i]).then((_) {
        print(i);
      }).catchError((error) {
        print(error);
      });
    }
  } */
}
