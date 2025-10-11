import 'package:flutter/material.dart';
import 'package:smartring_demo/histogram/histogram.dart';
import 'package:smartring_demo/main.dart';

class Aktywnosc extends StatefulWidget {
  const Aktywnosc({ super.key });

  @override
  State<Aktywnosc> createState() => _AktywnoscState();
}

class _AktywnoscState extends State<Aktywnosc> {

  // Lista liczby kroków w tygodniu
  List<int> tygodniowePodsumowanie = [5040, 6490, 2904, 10075, 7099, 12349, 8004];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 155, 197),
        title: Center(
          child: Text('Aktywność'),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/tlo_aktywnosc.jpg', 
              fit: BoxFit.cover, 
            ),
          ),
          Center(
          child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 30.0,
                children: <Widget>[
                  MainShape(kolor: const Color.fromARGB(255, 130, 167, 197), nazwa: 'kroki => 5607'),
                  SizedBox(
                    height: 200,
                    child: MyHistogram(tygodniowePodsumowanie: tygodniowePodsumowanie,),
                  ),
                  MainShape(kolor: const Color.fromARGB(255, 130, 167, 197), nazwa: 'spaone kalorie => 590'),
                  MainShape(kolor: const Color.fromARGB(255, 130, 167, 197), nazwa: 'przebyty dystans => 5 km'),
                ],
              ),
      ),],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, '/glowny');
        },
        backgroundColor: const Color.fromARGB(255, 64, 155, 197),
        child: const Icon(Icons.home),
      ),
    );
  }
}