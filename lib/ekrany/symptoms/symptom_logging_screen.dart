import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smartring_demo/services/database_service.dart';
import 'package:smartring_demo/models/symptom.dart';

class Symptoms extends StatefulWidget {
  final DatabaseService databaseService;

  const Symptoms({super.key, required this.databaseService});
  @override
  State<Symptoms> createState() => _SymptomsState();
}

class _SymptomsState extends State<Symptoms> {
  String? selectedSymptom;
  SymptomCategory? selectedCategory;
  int intensity = 3;
  String notes = '';
  List<Symptom> todaySymptoms = [];
  bool _isLoading = false;
  int myIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadSymptoms();
  }

  Future<void> _loadSymptoms() async {
    setState(() {
      _isLoading = true;
    });
    final data = await widget.databaseService.getSymptomsForDate(
      DateTime.now(),
    );
    setState(() {
      todaySymptoms = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Objawy',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: todaySymptoms.length,
              itemBuilder: (contex, index) {
                final s = todaySymptoms[index];
                return ListTile(
                  title: Text(s.symptomType),
                  subtitle: Text("intensity: ${s.intensity}"),
                );
              },
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
    );
  }
}
