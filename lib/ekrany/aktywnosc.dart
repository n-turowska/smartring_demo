import 'package:flutter/material.dart';
import 'package:smartring_demo/main.dart';

class Aktywnosc extends StatelessWidget {
  const Aktywnosc({ super.key });

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
              'assets/tlo_niebieskie.jpg', 
              fit: BoxFit.cover, 
            ),
          ),
          Center(
          child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 30.0,
                children: <Widget>[
                  MainShape(kolor: const Color.fromARGB(255, 130, 167, 197), nazwa: 'kroki => 5607'),
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