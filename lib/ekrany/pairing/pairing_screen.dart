import 'package:flutter/material.dart';
import '/services/ble_service.dart';


class PairingScreen extends StatefulWidget{
  
    const PairingScreen({super.key});

    @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Parowanie"),
      ),
      body: Text("Ekran parowania"),

    );
  }
}