import 'package:flutter/material.dart';
import 'package:smartring_demo/ekrany/cykl.dart';
import 'package:smartring_demo/services/database_helper.dart';
import 'package:smartring_demo/services/database_service.dart';

class StartowyEkran extends StatefulWidget {
  const StartowyEkran({super.key, required this.title});

  final String title;

  @override
  State<StartowyEkran> createState() => _StartowyEkranState();
}

class _StartowyEkranState extends State<StartowyEkran> {
  int myIndex = 1;
  int dlugoscCyklu = 28;
  int get dzienOwulacji => dlugoscCyklu - 14;
  DateTime _kliknietyDzien = DateTime.now();
  int? _daysUntilNextPeriodStart;

  int? getCurrentOvulation() {
    final repo = DatabaseService
        .instance; //musi byc instancja zeby sie moc odwolac do ovulationDays, czyli do gettera
    final today = _kliknietyDzien;
    try {
      final currentOvulation = repo.ovulationDays.firstWhere(
        (i) => i.date.year == today.year && i.date.month == today.month,
      );
      return currentOvulation.date.day;
    } catch (e) {
      return 15;
    }
  }

  int? getPredictedDlugoscCyklu() {
    final repo = DatabaseService.instance;
    final dlCyklu = repo.dlCyklu.first;
    dlugoscCyklu = dlCyklu;
    return dlugoscCyklu;
  }

  Future<void> _loadDaysUntilNextPeriod() async {
    final lastPeriodStart = await DatabaseService.instance.getLastPeriodStart();
    final avrCycleLength = await DatabaseService.instance
        .calculateAverageCycleLength();

    if (lastPeriodStart != null && avrCycleLength != null) {
      final nextPeriodStart = lastPeriodStart.add(
        Duration(days: avrCycleLength.toInt()),
      );
      _daysUntilNextPeriodStart = nextPeriodStart
          .difference(DateTime.now())
          .inDays;
    } else {
      _daysUntilNextPeriodStart = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDaysUntilNextPeriod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text("Podsumowanie", textAlign: TextAlign.left),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        selectedItemColor: Color.fromARGB(255, 217, 127, 201),
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
          if (index == 0) {
            Navigator.pushNamed(context, '/parowanie');
          }
          if (index == 1) {
            Navigator.pushNamed(context, '/startowy');
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/glowny');
          }
        },
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
      body: Stack(
        children: [
          Center(
            child: Column(
              spacing: 80.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /*ElevatedButton(
                  onPressed: () async {
                    print("KLIK");
                    final db = await DatabaseHelper.instance.database;
                    print("KLIK2");
                    final tables = await db.rawQuery(
                      "SELECT name FROM sqlite_master WHERE type='table'",
                    );

                    print(tables);
                  },
                  child: Text("Sprawdź tabele"),
                ),*/
                //do testowania czy tworza sie tabele
                Container(
                  height: 100,
                  width: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ), //do zaokraglenia rogow
                    color: Color.fromARGB(255, 255, 255, 255), //kolor tla
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
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(context, '/aktywnosc');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ),
                        ),
                        child: Text(
                          'Kroki',
                          style: TextStyle(
                            height: 2,
                            fontSize: 25,
                            color: const Color.fromARGB(255, 62, 10, 147),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 90,
                              height: 90,
                              child: CircularProgressIndicator(
                                value: 1,
                                color: const Color.fromARGB(255, 62, 10, 147),
                              ),
                            ),
                            Text(" 5607\nkroków"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ), //do zaokraglenia rogow
                    color: Color.fromARGB(255, 255, 255, 255), //kolor tla
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(context, '/zdrowie');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ),
                        ),
                        child: Text(
                          'Sen',
                          style: TextStyle(
                            height: 2,
                            fontSize: 25,
                            color: const Color.fromARGB(255, 7, 230, 70),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 90,
                              height: 90,
                              child: CircularProgressIndicator(
                                value: 1,
                                color: const Color.fromARGB(255, 7, 230, 70),
                              ),
                            ),
                            Text("   8h\nspania"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ), //do zaokraglenia rogow
                    color: Color.fromARGB(255, 255, 255, 255), //kolor tla
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

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(context, '/caly_cykl');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ),
                        ),
                        child: Text(
                          'Cykl',
                          style: TextStyle(
                            height: 2,
                            fontSize: 25,
                            color: const Color.fromARGB(255, 235, 53, 183),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 90,
                              height: 90,
                              child: CircularProgressIndicator(
                                value: 1,
                                color: const Color.fromARGB(255, 235, 53, 183),
                              ),
                            ),
                            Text(
                              "okres za\n  ${_daysUntilNextPeriodStart ?? '?'} dni",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
