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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Więcej',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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
          BottomNavigationBarItem(icon: Icon(Icons.more), label: "Więcej"),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              spacing: 20.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 70,
                  width: 230,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/aktywnosc');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Text(
                      'Aktywność',
                      style: TextStyle(
                        height: 2,
                        fontSize: 25,
                        color: const Color.fromARGB(255, 62, 10, 147),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 230,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/zdrowie');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Text(
                      'Zdrowie',
                      style: TextStyle(
                        height: 2,
                        fontSize: 25,
                        color: const Color.fromARGB(255, 7, 230, 70),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 230,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/cykl');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
