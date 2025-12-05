import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int myIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Więcej',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
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
      body: Stack(
        children: [
          Center(
            child: Column(
              spacing: 50.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 70,
                  width: 230,
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
                      const SizedBox(width: 15),
                      Text(
                        'Aktywność',
                        style: TextStyle(
                          height: 2,
                          fontSize: 25,
                          color: const Color.fromARGB(255, 62, 10, 147),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, '/aktywnosc');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            backgroundColor: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
                            ),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 70,
                  width: 230,
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
                      const SizedBox(width: 15),
                      Text(
                        'Zdrowie',
                        style: TextStyle(
                          height: 2,
                          fontSize: 25,
                          color: const Color.fromARGB(255, 7, 230, 70),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, '/zdrowie');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            backgroundColor: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
                            ),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 70,
                  width: 230,
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
                      const SizedBox(width: 15),
                      Text(
                        'Cykl',
                        style: TextStyle(
                          height: 2,
                          fontSize: 25,
                          color: const Color.fromARGB(255, 235, 53, 183),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, '/cykl');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            backgroundColor: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //MainShape(kolor: Colors.grey, nazwa: 'segment testowy'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
