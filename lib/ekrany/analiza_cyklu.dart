import 'package:flutter/material.dart';
import 'package:smartring_demo/services/database_service.dart';
import 'package:intl/intl.dart';

class CycleAnalysisScreen extends StatefulWidget {
  final DatabaseService databaseService;
  const CycleAnalysisScreen({super.key, required this.databaseService});

  @override
  State<CycleAnalysisScreen> createState() => _CycleAnalysisScreenState();
}

class _CycleAnalysisScreenState extends State<CycleAnalysisScreen> {
  @override
  int myIndex = 1;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Analiza cyklu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
          if (index == 0) {
            Navigator.pushNamed(context, '/parowanie');
          }
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
      body: Center(child: Text('analiza')),
    );
  }
}
