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
      body: Stack(
        //zeby tlo nie przykrylo pozniejszych elementow dajemy stack-stos
        fit: StackFit.expand,
        children: [
          Image.asset('assets/tlo_pastel.jpg', fit: BoxFit.cover),
          Column(
            spacing: 20.0,
            //scaffold ma jeden widget wiec column musi byc w stack
            mainAxisAlignment: MainAxisAlignment.center, //zeby bylo na srodku
            children: [
              //Image.asset('assets/polneKwiatki', width: 25), //dodanie obrazka
              Container(
                height: 50,
                width: 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 197, 52, 156),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                //padding: EdgeInsets.all(20), //odleglosc tekstu od krawedzi
                alignment: Alignment.center,
                child: Text(
                  'dzień cyklu: ',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium!.copyWith(color: Colors.white),
                ),
              ),
              Container(
                height: 50,
                width: 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 197, 52, 156),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                alignment: Alignment.center,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'do miesiączki: $ilosc_dni_do_miesiaczki dni',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.copyWith(color: Colors.white),
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
                height: 50,
                width: 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 197, 52, 156),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'dni z bolącym brzuchem: $ilosc_dni_boli_brzuch ',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.copyWith(color: Colors.white),
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
              ),
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, '/glowny');
        },
        backgroundColor: const Color.fromARGB(255, 210, 176, 230),
        child: const Icon(Icons.home),
      ),
    );
  }
}
