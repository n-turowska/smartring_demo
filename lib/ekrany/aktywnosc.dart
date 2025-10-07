import 'package:flutter/material.dart';
import 'package:smartring_demo/main.dart';

class Aktywnosc extends StatelessWidget {
  const Aktywnosc({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Center(
          child: Text('Aktywność'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.0,
          children: <Widget>[
            MainShape(kolor: Colors.blueGrey, nazwa: 'kroki => 5607'),
            MainShape(kolor: Colors.blueGrey, nazwa: 'spaone kalorie => 590'),
            MainShape(kolor: Colors.blueGrey, nazwa: 'przebyty dystans => 5 km'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, '/glowny');
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}