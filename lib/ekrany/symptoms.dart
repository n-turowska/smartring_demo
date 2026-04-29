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
  List<Symptom> _symptoms = [];
  bool _isLoading = false;

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
      _symptoms = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Objawy")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _symptoms.length,
              itemBuilder: (contex, index) {},
            ),
    );
  }
}
