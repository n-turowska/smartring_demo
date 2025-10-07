import 'package:flutter/material.dart';
import 'package:smartring_demo/main.dart';

class Cykl extends StatelessWidget {
  const Cykl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //gora ekranu
        title: const Text(
          'Cykl',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, //grubosc czcionki
          ),
        ),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, //zeby bylo rozciagniete na cala dlugosc
        mainAxisAlignment: MainAxisAlignment.center, //zeby bylo na srodku
        children: [
          Image.asset('asset/polneKwiatki', width: 25), //dodanie obrazka
          Container(
            color: Colors.blueAccent,
            padding: EdgeInsets.all(20), //odleglosc tekstu od krawedzi
            child: const Text('dzień cyklu: '),
          ),
          Container(
            color: Colors.blueAccent,
            padding: EdgeInsets.all(20),
            child: const Text('dni do miesiączki: '),
          ),
          Container(
            color: Colors.blueAccent,
            padding: EdgeInsets.all(20),
            child: const Text('prawdopodobieństwo zajścia w ciążę: '),
          ),
        ],
      ),
    );
  }
}
