import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _click = 0;
  late final DatabaseReference _clickRef;
  late StreamSubscription<DatabaseEvent> _clickSubscription;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _clickRef = FirebaseDatabase.instance.ref('clicks');
    try {
      final clickSnapshot = await _clickRef.get();
      _click = clickSnapshot.value as int;
    } catch (erro) {
      debugPrint(erro.toString());
    }

    _clickSubscription = _clickRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        _click = (event.snapshot.value ?? 0) as int;
      });
    });
  }

  numberClicks() async {
    await _clickRef.set(ServerValue.increment(1));
  }

  @override
  void dispose() {
    _clickSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'firebaseLOGO.png',
          width: 120,
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(50),
              child: Image.asset(
                'imgHome.png',
                width: 400,
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            const Text(
              'Você clicou no botão esse número de vezes:',
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              _click.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              "2022 \u00a9 Author ' Pedro Ruffo '",
              style: TextStyle(fontSize: 12),
            ),
          ),
          FloatingActionButton(
            onPressed: numberClicks,
            tooltip: 'adicionar',
            backgroundColor: Colors.amber[700],
            child: const Icon(Icons.add),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
