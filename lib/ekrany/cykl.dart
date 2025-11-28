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
  double rozmiar_czcionki = 22;
  //kolory
  final Kolor = const Color.fromARGB(255, 252, 212, 232);
  final Kolor_tekstu = Colors.black;
  final Kolor_przycisku = Color.fromARGB(255, 236, 161, 202);

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
  List<dynamic> _deletedEvents = [];

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
      final userEvents = await widget.databaseService.getUserEvents();
      final predictedOvulation = await widget.databaseService
          .getAllOvulationDays();

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

      setState(() {
        _eventsByDay = grouped;
        _wybraneEventy.value = _wezEventyForDay(_kliknietyDzien!);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Nie udało się załadować: &e';
        _isLoading = false;
      });
    }
  }

  List<dynamic> _wezEventyForDay(DateTime day) {
    final events =
        _eventsByDay[DateTime(day.year, day.month, day.day)] ??
        []; //jesli _eventsByDay jest null to zwroci pusta liste;
    return events.where((e) => !_deletedEvents.contains(e)).toList();
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
    final newEvent = Event(title, day);
    widget.databaseService.addUserEvent(newEvent);
    final date = DateTime(day.year, day.month, day.day);
    _eventsByDay[date] = (_eventsByDay[date] ?? [])..add(newEvent);
    _wybraneEventy.value = _wezEventyForDay(day);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage != null) return Center(child: Text(_errorMessage!));

    return Scaffold(
      appBar: AppBar(
        //gora ekranu
        title: const Text(
          'Kalendarz',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            //grubosc czcionki
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
                  '${14 + dzisiaj.day - 15} dzień cyklu', //14dziencyklu(owulacja)-dzien dzisiejszy-dzien owulacji
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Kolor_tekstu,
                    fontSize: rozmiar_czcionki,
                  ),
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
                      '${14 + 15 - dzisiaj.day} dni do miesiączki', //14dziencyklu(owulacja)+dzien owulacji-dzien dzisiejszy
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(
                            color: Kolor_tekstu,
                            fontSize: rozmiar_czcionki,
                          ),
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
                height: 280,
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
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (hasOvulation)
                            const Icon(
                              Icons.favorite,
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
                height: 80,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ValueListenableBuilder<List<dynamic>>(
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

                              title: Center(child: Text(value[index].title)),
                              trailing: value[index] is Event
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                      onPressed: () async {
                                        final date = _kliknietyDzien;
                                        await widget.databaseService
                                            .deleteEvent(value[index]);
                                        _eventsByDay[date]?.removeWhere(
                                          (e) => e.id == value[index].id,
                                        );
                                        _deletedEvents.add(value[index]);
                                        _wybraneEventy.value =
                                            _eventsByDay[date] ?? [];
                                        setState(() {});
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
              /*Container(
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
              )*/
              /*Container(
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
              )*/
              /*Container(
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
              )*/
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, '/glowny');
        },
        backgroundColor: Kolor_przycisku,
        child: const Icon(Icons.home),
      ),
    );
  }
}
