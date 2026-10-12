import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smartring_demo/services/database_service.dart';
import 'package:smartring_demo/models/symptom.dart';
import 'widgets/symptom_button.dart';
import 'widgets/intensity_slider.dart';

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
  DateTime selectedDate = DateTime.now();
  int? editingSymptomId;

  List<SymptomType> get physicalSymptoms =>
      DatabaseService.instance.physicalSymptoms;
  List<SymptomType> get moodSymptoms => DatabaseService.instance.moodSymptoms;

  @override
  void initState() {
    super.initState();
    _loadSymptoms();
  }

  Future<void> _loadSymptoms() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await widget.databaseService.getSymptomsForDate(
        selectedDate,
      );
      setState(() {
        todaySymptoms = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd ładowania objawów: ${e.toString()}')),
      );
    }
  }

  void _selectSymptom(SymptomType symptomType) {
    setState(() {
      selectedSymptom = symptomType.id;
      selectedCategory = symptomType.category;
    });
  }

  Future<void> _saveSymptom() async {
    if (selectedSymptom == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Wybierz objaw")));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final allSymptoms = [...physicalSymptoms, ...moodSymptoms];
      final symptomType = allSymptoms.firstWhere(
        (s) => s.id == selectedSymptom,
      );
      final newSymptom = Symptom(
        id: editingSymptomId,
        date: DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
        symptomType: symptomType.id,
        category: symptomType.category,
        intensity: intensity,
        notes: notes.isEmpty ? null : notes,
        created_at: editingSymptomId != null
            ? todaySymptoms
                  .firstWhere((s) => s.id == editingSymptomId)
                  .created_at
            : DateTime.now().toIso8601String(),
      );
      if (editingSymptomId != null) {
        await widget.databaseService.updateSymptom(newSymptom);
      } else {
        await widget.databaseService.addSymptom(newSymptom);
      }
      await _loadSymptoms();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            editingSymptomId != null
                ? 'Objaw zaaktualizowany'
                : 'Objaw zapisany!',
          ),
        ),
      );

      setState(() {
        selectedSymptom = null;
        selectedCategory = null;
        intensity = 3;
        notes = '';
        _isLoading = false;
        editingSymptomId = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Błąd: ${e.toString()}')));
    }
  }

  Future<void> _deleteSymptom(int symptomId) async {
    setState(() => _isLoading = true);
    try {
      await widget.databaseService.deleteSymptom(symptomId);
      await _loadSymptoms();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Błąd usuwania: ${e.toString()}')));
    }
  }

  void _editSymptom(Symptom symptom) {
    final allSymptoms = [...physicalSymptoms, ...moodSymptoms];
    final symptomType = allSymptoms.firstWhere(
      (s) => s.id == symptom.symptomType,
    );
    setState(() {
      editingSymptomId = symptom.id;
      selectedSymptom = symptom.symptomType;
      selectedCategory = symptom.category;
      intensity = symptom.intensity;
      notes = symptom.notes ?? '';
    });
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 300),
    );
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Data: ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2035),
                              );
                              if (picked != null && picked != selectedDate) {
                                setState(() {
                                  selectedDate = picked;
                                  editingSymptomId = null;
                                });
                                await _loadSymptoms();
                              }
                            },
                            child: const Text('Zmień datę'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //physical
                  const Text(
                    'Fizyczne',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 235, 53, 183),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: physicalSymptoms
                        .map(
                          (symptom) => SymptomButton(
                            symptomType: symptom,
                            isSelected: selectedSymptom == symptom.id,
                            onTap: () => _selectSymptom(symptom),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  //mood
                  const Text(
                    'Nastrój',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 235, 53, 183),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: moodSymptoms
                        .map(
                          (symptom) => SymptomButton(
                            symptomType: symptom,
                            isSelected: selectedSymptom == symptom.id,
                            onTap: () => _selectSymptom(symptom),
                          ),
                        )
                        .toList(),
                  ),

                  if (selectedSymptom != null) ...[
                    const SizedBox(height: 20),
                    //suwak intensywności
                    IntensitySlider(
                      value: intensity,
                      onChanged: (value) => setState(() {
                        intensity = value;
                      }),
                    ),
                    const SizedBox(height: 20),
                    //notes
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Notatki (opcjonalne)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      maxLines: 3,
                      onChanged: (value) => setState(() => notes = value),
                    ),
                    const SizedBox(height: 20),
                    //saving button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            235,
                            53,
                            183,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        onPressed: _saveSymptom,
                        child: Text(
                          editingSymptomId != null
                              ? 'Zaaktualizuj objaw'
                              : 'Zapisz objaw',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (todaySymptoms.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Dzisiejsze objawy:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...todaySymptoms.map((symptom) {
                      final allSymptomsList = [
                        ...physicalSymptoms,
                        ...moodSymptoms,
                      ];
                      final symptomType = allSymptomsList.firstWhere(
                        (s) => s.id == symptom.symptomType,
                        orElse: () => allSymptomsList.first,
                      );
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Text(
                            symptomType.icon,
                            style: const TextStyle(fontSize: 20),
                          ),
                          title: Text(symptomType.namePolish),
                          subtitle: Text(
                            'Intensywność: ${symptom.intensity}/5${symptom.notes != null ? ' | ${symptom.notes}' : ''}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _editSymptom(symptom),
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                                onPressed: symptom.id != null
                                    ? () => _deleteSymptom(symptom.id!)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ],
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
    );
  }
}
