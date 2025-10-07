import 'package:flutter/material.dart';
import 'package:smartring_demo/main.dart';

class Cykl extends StatefulWidget {
  const Cykl({super.key});

  @override
  State<Cykl> createState() => _CyklState();
}

class _CyklState extends State<Cykl> {
  int ilosc_dni_boli_brzuch = 0;
  int ilosc_dni_do_miesiaczki = 0;

  void zwiekszenie_dni() {
    setState(() {
      //sprawia ze klikniecie przycisku zwieksza ilosc dni na ekranie
      ilosc_dni_boli_brzuch = ilosc_dni_boli_brzuch < 7
          ? ilosc_dni_boli_brzuch + 1
          : 0;
    });
  }

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
          Image.asset('assets/polneKwiatki', width: 25), //dodanie obrazka
          Container(
            color: Colors.blueAccent,
            padding: EdgeInsets.all(20), //odleglosc tekstu od krawedzi
            child: const Text('dzień cyklu: '),
          ),
          Container(
            color: Colors.blueAccent,
            padding: EdgeInsets.all(20),
            child: Stack(
              children: [
                Text('dni do miesiączki: $ilosc_dni_do_miesiaczki'),
                Image.asset(
                  'assets/kropelka.jpg',
                  width: 25,
                  color: Colors.blueAccent,
                  colorBlendMode: BlendMode.multiply,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.blueAccent,
            padding: EdgeInsets.all(20),
            child: Text('dni z bolącym brzuchem: $ilosc_dni_boli_brzuch '),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            onPressed: zwiekszenie_dni,
            child: const Text('+'),
          ),
        ],
      ),
    );
  }
}
