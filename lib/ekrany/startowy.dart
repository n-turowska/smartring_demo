import 'package:flutter/material.dart';
import 'package:smartring_demo/ekrany/cykl.dart';
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

  int? getCurrentOvulation() {
    final repo = DatabaseService
        .instance; //musi byc instancja zeby sie moc odwolac do ovulationDays, czyli do gettera
    final today = _kliknietyDzien;
    final currentOvulation = repo.ovulationDays.firstWhere(
      (i) => i.date.year == today.year && i.date.month == today.month,
    );
    return currentOvulation.date.day;
  }

  int? getPredictedDlugoscCyklu() {
    final repo = DatabaseService.instance;
    final dlCyklu = repo.dlCyklu.first;
    dlugoscCyklu = dlCyklu;
    return dlugoscCyklu;
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
                          Navigator.popAndPushNamed(context, '/cykl');
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
                              "okres za\n  ${(dzienOwulacji + getCurrentOvulation()! - DateTime.now().day) % getPredictedDlugoscCyklu()!} dni",
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
