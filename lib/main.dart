import 'package:flutter/material.dart';
import 'package:smartring_demo/ekrany/aktywnosc.dart';
import 'package:smartring_demo/ekrany/zdrowie.dart';
import 'package:smartring_demo/ekrany/cykl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/glowny',
      routes: {
        '/aktywnosc': (context) => const Aktywnosc(),
        '/zdrowie': (context) => const Zdrowie(),
        '/cykl': (context) => const Cykl(),
        '/glowny': (context) => const MyHomePage(title: 'Mira Ring Demo Home Page'),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Center(
          child: Text('Witaj w Mira Ring'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/aktywnosc');
              }, 
              child: Text('Aktywność'),),
            ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/zdrowie');
              }, 
              child: Text('Zdrowie'),),
            ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/cykl');
              }, 
              child: Text('Cykl'),),
            MainShape(kolor: Colors.amber, nazwa: 'segment testowy'),
          ],
        ),
      ),
    );
  }
}

class MainShape extends StatelessWidget {
  final Color kolor;
  final String nazwa;

  const MainShape({ super.key, this.kolor = Colors.lightBlueAccent, required this.nazwa});

  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      color: kolor,
      alignment: Alignment.center,
      child: Text(nazwa,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.white)),
    );
  }
}