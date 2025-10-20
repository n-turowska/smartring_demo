import 'package:flutter/material.dart';
import 'package:smartring_demo/main.dart';
import 'package:table_calendar/table_calendar.dart';

class Cykl extends StatefulWidget {
  const Cykl({super.key});

  @override
  State<Cykl> createState() => _CyklState();
}

class _CyklState extends State<Cykl> {
  //do przycisków
  int ilosc_dni_boli_brzuch = 0;
  int ilosc_dni_do_miesiaczki = 1;

  //kolory
  final Kolor = const Color.fromARGB(255, 252, 212, 232);
  final Kolor_tekstu = Colors.black;

  //do kalendarza
  DateTime dzisiaj = DateTime.now();
  DateTime? _kliknietyDzien;
  DateTime? _terazniejszyDzien;

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
            color: Colors.black,
            fontWeight: FontWeight.bold, //grubosc czcionki
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 236, 161, 202),
        centerTitle: true,
      ),
      body: Stack(
        //zeby tlo nie przykrylo pozniejszych elementow dajemy stack-stos
        fit: StackFit.expand,
        children: [
          Image.asset(
            //'assets/tlo.png',
            'assets/tlo_tel_cykl.png',
            fit: BoxFit.cover,
          ),
          Column(
            spacing: 20.0,
            //scaffold ma jeden widget wiec column musi byc w stack
            mainAxisAlignment: MainAxisAlignment.center, //zeby bylo na srodku
            children: [
              /*Image.asset(
                'assets/kalendarz1.png',
                width: 250,
                height: 250,
                //color: const Color.fromARGB(255, 193, 187, 190),
                //colorBlendMode: BlendMode.multiply,
              ), //dodanie obrazka
              */
              Container(
                child: TableCalendar(
                  locale: Localizations.localeOf(
                    context,
                  ).toString(), //toString zamienia na tekst "pl_PL", a to wczesniej pobiera atualny jezyk aplikacji
                  rowHeight: 40, //odleglosc miedzy wierszami
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false, //zeby zniknal napis '2weeks'
                  ),
                  availableGestures: AvailableGestures
                      .all, //zeby mozna bylo przewijac, przeciagac-co sie chce
                  selectedDayPredicate: (dzien) {
                    return isSameDay(_kliknietyDzien, dzien);
                  },
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2035, 10, 16),
                  focusedDay: dzisiaj,
                  onDaySelected: (kliknietyDzien, terazniejszyDzien) {
                    setState(() {
                      _kliknietyDzien = kliknietyDzien;
                      _terazniejszyDzien = terazniejszyDzien;
                    });
                  },
                ),
              ),
              Container(
                height: 50,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Kolor,
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
                  'dzień cyklu: 28',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium!.copyWith(color: Kolor_tekstu),
                ),
              ),
              Container(
                height: 50,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Kolor,
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
                      ).textTheme.headlineMedium!.copyWith(color: Kolor_tekstu),
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
                        color: Kolor,
                        colorBlendMode: BlendMode.multiply,
                      ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Kolor,
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
                      'bolący brzuch: $ilosc_dni_boli_brzuch ',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.copyWith(color: Kolor_tekstu),
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
        backgroundColor: const Color.fromARGB(255, 236, 161, 202),
        child: const Icon(Icons.home),
      ),
    );
  }
}
