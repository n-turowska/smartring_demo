import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ekrany/aktywnosc.dart';
import 'ekrany/zdrowie.dart';
import 'ekrany/startowy.dart';
import 'ekrany/wiecej.dart';
import 'ekrany/cykl.dart';
import 'ekrany/parowanie.dart';
import 'services/database_service.dart';
import 'services/ring_service.dart';
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
      initialRoute: '/startowy',
      routes: {
        '/startowy': (context) => const StartowyEkran(title: 'Startowy Ekran'),
        '/aktywnosc': (context) =>
            Aktywnosc(databaseService: DatabaseService.instance),
        '/zdrowie': (context) => const Zdrowie(),
        '/cykl': (context) => Cykl(databaseService: DatabaseService.instance),
        '/parowanie': (context) =>
            Parowanie(ringService: RingService.instance),
        '/glowny': (context) =>
            const MyHomePage(title: 'Mira Ring Demo More Page'),
      },
      localizationsDelegates: GlobalMaterialLocalizations
          .delegates, //zeby tlumaczylo na jezyk systemowy uzytkownika
      supportedLocales: const [Locale('pl'), Locale('en')], //dostepne jezyki
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
