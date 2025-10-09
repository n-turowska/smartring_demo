import 'package:flutter/material.dart';
import 'package:smartring_demo/main.dart';

class Cykl extends StatefulWidget {
  const Cykl({super.key});

  @override
  State<Cykl> createState() => _CyklState();
}

class _CyklState extends State<Cykl> {
  int ilosc_dni_boli_brzuch = 0;
  int ilosc_dni_do_miesiaczki = 3;

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
          'Mój Cykl',
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
          //Image.asset('assets/polneKwiatki', width: 25), //dodanie obrazka
          Container(
            color: const Color.fromARGB(255, 201, 84, 212),
            padding: EdgeInsets.all(20), //odleglosc tekstu od krawedzi
            child: const Text(
              'dzień cyklu: ',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 201, 84, 212),
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'do miesiączki: $ilosc_dni_do_miesiaczki dni',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ), //zeby byla przerwa miedzy tekstem a obrazkiem
                for (
                  int i = 0;
                  i < 4 - ilosc_dni_do_miesiaczki;
                  i++
                ) //wyswietlenie kropelek obok napisu
                  Image.asset(
                    'assets/kropelka.jpg',
                    width: 25,
                    color: const Color.fromARGB(255, 164, 30, 79),
                    colorBlendMode: BlendMode.multiply,
                  ),
              ],
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 201, 84, 212),
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text('dni z bolącym brzuchem: $ilosc_dni_boli_brzuch '),
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
          ),
        ],
      ),
    );
  }
}
