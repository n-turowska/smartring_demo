import 'package:flutter/material.dart';
import 'package:smartring_demo/ekrany/kalendarz/event.dart';
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
  DateTime _kliknietyDzien =
      DateTime.now(); // _ jest po to zeby nie dalo sie modiikowac tych zmiennych spoza klasy i deklarujemy od razu zeby nie byl null, jesli nie klikniemy w dzien na kalendarzu, a damy edit kalendarza
  //int get ilosc_dni_do_miesiaczki => _wybraneEventy.day - dzisiaj.day;

  Map<DateTime, List<Event>> events =
      {}; //tworzymy map, ktora bedzie miala w sobie eventy-miesiaczke
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>>
  _wybraneEventy; //late-zainicjalizujemy ta zmienna pozniej, final-tylko raz inicjalizujemy, potem nie mozna zmienic, ValueNotifier przechowuje liste eventow i powiadamia widgety gdy ta lista sie zmienia

  @override
  void initState() {
    super.initState();
    _wybraneEventy = ValueNotifier(_wezEventyForDay(_kliknietyDzien!));
  }

  List<Event> _wezEventyForDay(DateTime day) {
    return events[day] ??
        []; //jesli events[day] jest null to zwroci pusta liste;
  }

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
              Padding(
                padding: EdgeInsets.only(top: 1, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        showDialog(
                          //otwieramy okno dialogowe
                          context:
                              context, //dzieki temu showDialog wie gdzie ma byc dodane okno dialogowe, czyli w miejscu tego przycisku-flutter znajduje navigator i pokazuje dialog nad ekranem
                          builder: (context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Text('Mój cykl: '),
                              content: Padding(
                                padding: EdgeInsets.all(
                                  8,
                                ), //dookola pola tekstowego przerwa 8 pikseli
                                child: TextField(controller: _eventController),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    events.addAll({
                                      _kliknietyDzien!: [
                                        //! mowi ze wiadomo ze tu nie bedzie null, czyli ze na pewno cos wpiszemy
                                        Event(_eventController.text),
                                      ],
                                    });
                                    Navigator.of(
                                      context,
                                    ).pop(); //dzieki temu jak klikniemy dodaj to sie zamyka okno dialogowe
                                    _wybraneEventy.value = _wezEventyForDay(
                                      _kliknietyDzien!,
                                    );
                                  },
                                  child: Text('dodaj'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),

              /*Image.asset(
                'assets/kalendarz1.png',
                width: 250,
                height: 250,
                //color: const Color.fromARGB(255, 193, 187, 190),
                //colorBlendMode: BlendMode.multiply,
              ), //dodanie obrazka
              */
              Container(
                width: 400,
                height: 280,
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
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2035, 10, 16),
                  focusedDay: dzisiaj,
                  selectedDayPredicate: (dzien) {
                    return isSameDay(
                      _kliknietyDzien,
                      dzien,
                    ); //dzien jest aktualnie rysowany w siatce, jesli true znaczy ze dzien jest rzeczywiscie tym co kliknal uzytkownik i jest wtedy podkreslany
                  },
                  onDaySelected: (kliknietyDzien, terazniejszyDzien) {
                    //
                    setState(() {
                      //zeby powiadomic ze zmienily sie wartosci trzeba przypisac
                      _kliknietyDzien = kliknietyDzien;
                      dzisiaj = terazniejszyDzien;
                      _wybraneEventy.value = _wezEventyForDay(
                        _kliknietyDzien!,
                      ); //zeby pokazywal sie event w zaleznosci od kliknietego dnia, a nie ciagle ten sam
                    });
                  },
                  eventLoader: _wezEventyForDay,
                  startingDayOfWeek: StartingDayOfWeek
                      .monday, //zeby byl od pn-ndz a nie ndz-sb
                  onPageChanged: (terazniejszyDzien) {
                    //informuje ktory miesiac jest aktualnie widoczny
                    setState(() {
                      dzisiaj =
                          terazniejszyDzien; //zmieniamy z tego miesiaca co byl z 'dzisiaj' i zmieniamy na ten klikniety
                    });
                  },
                ),
              ),

              Container(
                height: 80,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _wybraneEventy,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 80,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                15,
                              ), //do zaokraglenia rogow
                              color: Kolor, //kolor tla
                              boxShadow: [
                                //cienie
                                BoxShadow(
                                  color: Colors.grey.shade500, //kolor cienia
                                  offset: Offset(
                                    4.0,
                                    4.0,
                                  ), //przesunicie wzgledem kontenera
                                  blurRadius: 15.0, //rozmycie cienia
                                  spreadRadius: 1.0, //rozszerzenie cienia
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                            ),
                            child: ListTile(
                              onTap: () => print(""),
                              title: Text(value[index].title),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    15,
                  ), //do zaokraglenia rogow
                  color: Kolor, //kolor tla
                  boxShadow: [
                    //cienie
                    BoxShadow(
                      color: Colors.grey.shade500, //kolor cienia
                      offset: Offset(4.0, 4.0), //przesunicie wzgledem kontenera
                      blurRadius: 15.0, //rozmycie cienia
                      spreadRadius: 1.0, //rozszerzenie cienia
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
