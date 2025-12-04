import 'package:flutter/material.dart';
import '../widgets/common/main_shape.dart';
import '../services/database_service.dart';
import '../services/ring_service.dart';

class Parowanie extends StatefulWidget{
    final DatabaseService databaseService;


    const Parowanie({super.key,required this.databaseService,});

    @override
  State<Parowanie> createState() => _ParowanieState();
}

class _ParowanieState extends State<Parowanie> {

  RingConnectionState state = RingConnectionState.scanning;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, '/glowny');
        },
        backgroundColor: const Color.fromARGB(255, 64, 155, 197),
        child: const Icon(Icons.home),
      ),
    );
  }

  Widget _buildBody() {

    if(state==RingConnectionState.disconnected)
    {
      return const Center(
        child: Text("Ring is disconnected"),
      );
    }
    else if(state==RingConnectionState.scanning)
    {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Scanning"), CircularProgressIndicator(),]
        ),
      );
    }
    else if(state==RingConnectionState.connecting)
    {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Connecting"), CircularProgressIndicator(),]
        ),
      );
    }
    else if(state==RingConnectionState.connected)
    {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Ring is connected"),]
        ),
      );
    }
    else if(state==RingConnectionState.syncing)
    {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Scyncing"), CircularProgressIndicator(),]
        ),
      );
    }
    else{
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("ERROR"),]
        ),
      );
    }
  }
}