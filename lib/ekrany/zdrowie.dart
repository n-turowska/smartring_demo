import 'package:flutter/material.dart';
import '../widgets/common/main_shape.dart';
import '../wykres_zdrowie/wykres1.dart';

class Zdrowie extends StatefulWidget {
  const Zdrowie({super.key});

  @override
  State<Zdrowie> createState() => _ZdrowieState();
}

class _ZdrowieState extends State<Zdrowie> {
  @override
  Widget build(BuildContext context) {
    int myIndex = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 141, 227, 138),
        title: Center(
          child: Text(
            'Zdrowie',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/zielone_kształty.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10.0,
              children: <Widget>[
                MainShape(
                  kolor: Color.fromARGB(255, 34, 169, 88),
                  nazwa: "Ilość snu: 8h",
                ),
                MainShape(
                  kolor: Color.fromARGB(255, 34, 169, 88),
                  nazwa: "Dobowy HRV: 40ms",
                ),
                Stres(
                  kolor: Color.fromARGB(255, 34, 169, 88),
                  max_liczba: 5,
                  nazwa: "                Poziom stresu: ",
                ), //tak na daną chwilę, potem użyje Stack zamiac Row
                SizedBox(height: 200, width: 400, child: StressChart()),
                //Image.asset('assets/wykres.png', width: 400, height: 300, fit: BoxFit.contain),
              ],
            ),
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
    );
  }
}

class Stres extends StatefulWidget {
  final dynamic kolor;

  final dynamic nazwa;
  final dynamic max_liczba;

  const Stres({
    super.key,
    this.kolor = Colors.lightBlueAccent,
    required this.nazwa,
    required this.max_liczba,
  });

  @override
  State<Stres> createState() => _PoziomStresuState();
}

class _PoziomStresuState extends State<Stres> {
  int _counter = 0;

  //late final dynamic kolor;
  //late final dynamic nazwa;

  void _incrementCounter() {
    setState(() {
      if (_counter < widget.max_liczba) {
        _counter++;
      } else {
        _counter = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: widget.kolor,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.nazwa,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium!.copyWith(color: Colors.white),
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 141, 227, 138),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _incrementCounter,
              child: Text(
                '$_counter',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
