import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ekrany/aktywnosc.dart';
import 'ekrany/zdrowie.dart';
import 'ekrany/cykl.dart';
import 'ekrany/parowanie.dart';
import 'services/database_service.dart';
import 'core/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mira Ring Demo',
      theme: AppTheme.lightTheme,
      initialRoute: '/glowny',
      routes: {
        '/aktywnosc': (context) =>
            Aktywnosc(databaseService: DatabaseService.instance),
        '/zdrowie': (context) => const Zdrowie(),
        '/cykl': (context) => Cykl(databaseService: DatabaseService.instance),
        '/parowanie': (context) =>
            Parowanie(databaseService: DatabaseService.instance),
        '/glowny': (context) =>
            const MyHomePage(title: 'Mira Ring Demo Home Page'),
      },
      localizationsDelegates: GlobalMaterialLocalizations
          .delegates, //zeby tlumaczylo na jezyk systemowy uzytkownika
      supportedLocales: const [Locale('pl'), Locale('en')], //dostepne jezyki
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
        backgroundColor: const Color.fromARGB(255, 232, 226, 218),
        title: Center(
          child: Text(
            'Witaj w Mira Ring',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/tlo_główna.jpg', fit: BoxFit.cover),
          ),
          Center(
            child: Column(
              spacing: 20.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/aktywnosc');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 236, 199, 231),
                  ),
                  child: Text(
                    'Aktywność',
                    style: TextStyle(
                      height: 2,
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/zdrowie');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 236, 199, 231),
                  ),
                  child: Text(
                    'Zdrowie',
                    style: TextStyle(
                      height: 2,
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/cykl');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 236, 199, 231),
                  ),
                  child: Text(
                    'Cykl',
                    style: TextStyle(
                      height: 2,
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/parowanie');
                  },
                  child: Text('Połącz z pierścionkiem'),
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

class MainShape extends StatelessWidget {
  final Color kolor;
  final String nazwa;

  const MainShape({
    super.key,
    this.kolor = Colors.lightBlueAccent,
    required this.nazwa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: kolor,
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
      child: Text(
        nazwa,
        style: Theme.of(
          context,
        ).textTheme.headlineMedium!.copyWith(color: Colors.white),
      ),
    );
  }
}
