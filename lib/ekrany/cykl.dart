import 'dart:io';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'kalendarz/event.dart';
import 'package:smartring_demo/services/database_service.dart';

class Cykl extends StatefulWidget {
  final DatabaseService databaseService;

  const Cykl({super.key, required this.databaseService});

  @override
  State<Cykl> createState() => _CyklState();
}

class _CyklState extends State<Cykl> {
  //loading state
  bool _isLoading = true;
  String? _errorMessage;

  //do przycisków
  int ilosc_dni_boli_brzuch = 0;
  int ilosc_dni_do_miesiaczki = 14 + 15 - DateTime.now().day;
  double rozmiar_czcionki = 25;
  //kolory
  final Kolor = const Color.fromARGB(255, 252, 212, 232);
  final Kolor_tekstu = const Color.fromARGB(255, 235, 53, 183);
  final Kolor_przycisku = Colors.white;

  //do kalendarza
  late DateTime dzisiaj;
  DateTime? _kliknietyDzien =
      DateTime.now(); // _ jest po to zeby nie dalo sie modiikowac tych zmiennych spoza klasy i deklarujemy od razu zeby nie byl null, jesli nie klikniemy w dzien na kalendarzu, a damy edit kalendarza
  //int get ilosc_dni_do_miesiaczki => _wybraneEventy.day - dzisiaj.day;
  Map<DateTime, List<dynamic>> _eventsByDay =
      {}; //mapa wszystkich eventow-user+ovulation
  //Map<DateTime, List<Event>> events =
  //   {}; //tworzymy map, ktora bedzie miala w sobie eventy-miesiaczke
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<dynamic>>
  _wybraneEventy; //late-zainicjalizujemy ta zmienna pozniej, final-tylko raz inicjalizujemy, potem nie mozna zmienic, ValueNotifier przechowuje liste eventow i powiadamia widgety gdy ta lista sie zmienia

  int dlugoscCyklu = 28;
  int get dzienOwulacji => dlugoscCyklu - 14;
  int myIndex = 2;

  @override
  void initState() {
    super.initState();
    dzisiaj = DateTime.now();
    _wybraneEventy = ValueNotifier([]);
    _loadEvents();

    //_wybraneEventy = ValueNotifier(_wezEventyForDay(_kliknietyDzien!));
  }

  Future<void> _loadEvents() async {
    //Future, async i await powoduja ze program moze isc dalej pomimo ze to sie jeszcze nie wykona, a jak sie wykona to sie wtedy wyswietli i dzieki temu nic nie stoi i nie czeka na wykonanie tych linijek
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await _runAction(() async {
        final userEvents = await widget.databaseService.getUserEvents();
        final predictedOvulation = await widget.databaseService
            .getAllOvulationDays();
        final predictedMenstruation = await widget.databaseService
            .getAllMenstruationDays();

        //grupowanie po dniu
        final Map<DateTime, List<dynamic>> grouped = {};
        for (var e in userEvents) {
          final date = DateTime(e.date.year, e.date.month, e.date.day);
          grouped[date] = (grouped[date] ?? [])..add(e);
        }
        for (var i in predictedOvulation) {
          final date = DateTime(i.date.year, i.date.month, i.date.day);
          grouped[date] = (grouped[date] ?? [])..add(i);
        }
        for (var i in predictedMenstruation) {
          final date = DateTime(i.date.year, i.date.month, i.date.day);
          grouped[date] = (grouped[date] ?? [])..add(i);
        }

        setState(() {
          _eventsByDay = grouped;
          _wybraneEventy.value = _wezEventyForDay(_kliknietyDzien!);
          _isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Nie udało załadować się danych. Spróbuj ponownie';
        _isLoading = false;
      });
    }
  }

  List<dynamic> _wezEventyForDay(DateTime day) {
    return _eventsByDay[DateTime(day.year, day.month, day.day)] ??
        []; //jesli _eventsByDay jest null to zwroci pusta liste;
  }

  int? getCurrentOvulation() {
    final repo = DatabaseService
        .instance; //musi byc instancja zeby sie moc odwolac do ovulationDays, czyli do gettera
    final today = _kliknietyDzien ?? DateTime.now();

    try {
      final currentOvulation = repo.ovulationDays.firstWhere(
        (i) => i.date.year == today.year && i.date.month == today.month,
      );
      return currentOvulation.date.day;
    } catch (e) {
      return null;
    }
  }

  int? getPredictedDlugoscCyklu() {
    final repo = DatabaseService.instance;
    final dlCyklu = repo.dlCyklu.first;
    dlugoscCyklu = dlCyklu;
    return dlugoscCyklu;
  }

  /*void zwiekszenie_dni() {
    setState(() {
      //sprawia ze klikniecie przycisku zwieksza ilosc dni na ekranie
      ilosc_dni_boli_brzuch = ilosc_dni_boli_brzuch < 7
          ? ilosc_dni_boli_brzuch + 1
          : 0;
    });
  }*/
  //nowy event dodany przez uzytkownika
  Future<void> _addUserEvent(DateTime day, String title) async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    try {
      await _runAction(() async {
        final newEvent = Event(title, day);
        await widget.databaseService.addUserEvent(newEvent);
        final date = DateTime(day.year, day.month, day.day);
        _eventsByDay[date] = (_eventsByDay[date] ?? [])..add(newEvent);
        _wybraneEventy.value = _wezEventyForDay(day);
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Nie udało się dodać wydarzenia.';
        _isLoading = false;
      });
    }
  }

  Future<void> Function()? _lastFailedAction;

  Future<void> _runAction(Function() action) async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    try {
      await action();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Wystąpił błąd. Spróbuj ponownie.";
        _lastFailedAction = action();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.purple,
                decoration: TextDecoration.none,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_lastFailedAction != null) {
                  _runAction(_lastFailedAction!);
                }
              },
              child: const Text('Odśwież'),
            ),
          ],
        ),
      );
    }
    final ovulation = getCurrentOvulation();
    final cycleLength = getPredictedDlugoscCyklu();
    if (ovulation == null || cycleLength == null) {
      return const Center(
        child: Text(
          'Brak danych cyklu',
          style: TextStyle(
            color: Colors.purple,
            decoration: TextDecoration.none,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //gora ekranu
        title: const Text(
          'Kalendarz',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            //grubosc czcionki
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
      ),

      body: Stack(
        //zeby tlo nie przykrylo pozniejszych elementow dajemy stack-stos
        fit: StackFit.expand,
        children: [
          /*Image.asset(
            //'assets/tlo.png',
            'assets/tlo_tel_cykl.png',
            fit: BoxFit.cover,
          ),*/
          Column(
            spacing: 10.0,
            //scaffold ma jeden widget wiec column musi byc w stack
            mainAxisAlignment: MainAxisAlignment.center, //zeby bylo na srodku
            children: [
              Container(
                height: 100,
                width: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
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
                    Text.rich(
                      TextSpan(
                        text:
                            ((dzienOwulacji + ovulation - dzisiaj.day) %
                                        cycleLength !=
                                    0 &&
                                (dzienOwulacji + ovulation - dzisiaj.day) %
                                        cycleLength !=
                                    27 &&
                                (dzienOwulacji + ovulation - dzisiaj.day) %
                                        cycleLength !=
                                    26)
                            ? 'okres: za '
                            : '',
                        style: TextStyle(color: Colors.black, fontSize: 25),

                        children: [
                          TextSpan(
                            text:
                                ((dzienOwulacji + ovulation - dzisiaj.day) %
                                            cycleLength !=
                                        0 &&
                                    (dzienOwulacji + ovulation - dzisiaj.day) %
                                            cycleLength !=
                                        27 &&
                                    (dzienOwulacji + ovulation - dzisiaj.day) %
                                            cycleLength !=
                                        26)
                                ? '${(dzienOwulacji + ovulation - dzisiaj.day) % cycleLength} dni\n'
                                : '',
                            style: TextStyle(
                              color: Kolor_tekstu,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          TextSpan(
                            text: 'cykl: ',
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                          TextSpan(
                            text:
                                '${(dzienOwulacji + _kliknietyDzien!.day - ovulation - 1) % cycleLength + 1} dzień', //14dziencyklu(owulacja)+dzien owulacji-dzien dzisiejszy
                            style: TextStyle(
                              color: Kolor_tekstu,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*Text(
                      ((dzienOwulacji + ovulation - dzisiaj.day) %
                                      cycleLength !=
                                  0 &&
                              (dzienOwulacji +
                                          ovulation -
                                          dzisiaj.day) %
                                      cycleLength !=
                                  27 &&
                              (dzienOwulacji +
                                          ovulation -
                                          dzisiaj.day) %
                                      cycleLength !=
                                  26)
                          ? 'okres: za ${(dzienOwulacji + ovulation - dzisiaj.day) % cycleLength} dni\ncykl: ${(dzienOwulacji + _kliknietyDzien!.day - ovulation - 1) % cycleLength + 1} dzień'
                          : 'cykl: ${(dzienOwulacji + _kliknietyDzien!.day - ovulation - 1) % cycleLength + 1} dzień', //14dziencyklu(owulacja)+dzien owulacji-dzien dzisiejszy
                      //:'cykl: ${(dzienOwulacji + _kliknietyDzien!.day - ovulation - 1) % cycleLength + 1} dzień',
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(
                            color: Kolor_tekstu,
                            fontSize: rozmiar_czcionki,
                            fontWeight: FontWeight.normal,
                          ),
                    ),*/
                    /*const SizedBox(
                          width: 10,
                        ), */
                    //zeby byla przerwa miedzy tekstem a obrazkiem
                    /*for (
                          int i = 0;
                          i < 4 - ilosc_dni_do_miesiaczki;
                          i++
                        ) //wyswietlenie kropelek obok napisu
                          Image.asset(
                            'assets/kropelka.jpg',
                            width: 25,
                            color: Kolor,
                            colorBlendMode: BlendMode.multiply,
                          ),*/
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: Padding(
                  padding: EdgeInsets.only(top: 0, right: 16),

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
                                title: Text(
                                  '${_kliknietyDzien!.day}-${_kliknietyDzien!.month}-${_kliknietyDzien!.year} : ',
                                ),
                                content: Padding(
                                  padding: EdgeInsets.all(
                                    8,
                                  ), //dookola pola tekstowego przerwa 8 pikseli
                                  child: TextField(
                                    controller: _eventController,
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      final date = _kliknietyDzien!;
                                      final puredate = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                      ); //zeby bylo bez godziny
                                      widget.databaseService.addUserEvent(
                                        Event(_eventController.text, puredate),
                                      );
                                      _eventsByDay[puredate] =
                                          (_eventsByDay[puredate] ?? [])..add(
                                            Event(
                                              _eventController.text,
                                              puredate,
                                            ),
                                          );
                                      _wybraneEventy.value =
                                          _eventsByDay[puredate]!;
                                      Navigator.of(
                                        context,
                                      ).pop(); //dzieki temu jak klikniemy dodaj to sie zamyka okno dialogowe
                                    },
                                    child: Text('dodaj'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        backgroundColor: Kolor_przycisku,
                        child: Icon(Icons.edit),
                      ),
                    ],
                  ),
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
                height: 300,
                child: TableCalendar<dynamic>(
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
                      final date = _kliknietyDzien!;
                      final puredate = DateTime(
                        date.year,
                        date.month,
                        date.day,
                      );
                      _wybraneEventy.value = _wezEventyForDay(
                        puredate,
                      ); //zeby pokazywal sie event w zaleznosci od kliknietego dnia, a nie ciagle ten sam
                    });
                  },
                  eventLoader: (day) {
                    final puredate = DateTime(day.year, day.month, day.day);
                    return _eventsByDay[puredate] ?? [];
                  },
                  startingDayOfWeek: StartingDayOfWeek
                      .monday, //zeby byl od pn-ndz a nie ndz-sb
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return null;
                      final hasUserEvent = events.any((e) => e is Event);
                      final hasOvulation = events.any(
                        (e) => e is PredictedOvulation,
                      );
                      final hasMenstruation = events.any(
                        (e) => e is PredictedMenstruation,
                      );
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (hasOvulation)
                            const Icon(
                              Icons.circle_sharp,
                              size: 10,
                              color: Color.fromARGB(255, 118, 117, 109),
                            ),
                          if (hasMenstruation)
                            for (int i = 0; i < 3; i++)
                              const Icon(
                                Icons.opacity,
                                size: 10,
                                color: Colors.pink,
                              ),

                          if (hasUserEvent)
                            const Icon(
                              Icons.circle,
                              size: 7,
                              color: Color.fromARGB(255, 7, 52, 78),
                            ),
                        ],
                      );
                    },
                  ),
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
                height: 90,
                width: 290,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ValueListenableBuilder<List<dynamic>>(
                    valueListenable: _wybraneEventy,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 70,
                            width: 300,
                            margin: EdgeInsets.symmetric(
                              horizontal: 80,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                15,
                              ), //do zaokraglenia rogow
                              color: Colors.white, //kolor tla
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

                              title: Center(
                                child: Text(
                                  value[index].title,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              trailing: value[index] is Event
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _errorMessage = null;
                                          _isLoading = true;
                                        });
                                        try {
                                          await _runAction(() async {
                                            final date = DateTime(
                                              _kliknietyDzien!.year,
                                              _kliknietyDzien!.month,
                                              _kliknietyDzien!.day,
                                            );

                                            await widget.databaseService
                                                .deleteEvent(value[index]);
                                            _eventsByDay[date]?.removeWhere(
                                              (e) => e.id == value[index].id,
                                            );
                                            _wybraneEventy.value = List.from(
                                              _wezEventyForDay(date),
                                            );
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          });
                                        } catch (e) {
                                          setState(() {
                                            _errorMessage =
                                                'Nie udało się usunąć wydarzenia.';
                                            _isLoading = false;
                                          });
                                        }
                                      },
                                    )
                                  : null,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
          if (index == 1) {
            Navigator.pushNamed(context, '/startowy');
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/glowny');
          }
        },
        backgroundColor: Colors.white,
        selectedItemColor: Color.fromARGB(255, 217, 127, 201),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Mój Ring',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Podsumowanie",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: "Więcej",
          ),
        ],
      ),
    );
  }
}
