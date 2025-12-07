import 'package:flutter/material.dart';
import '../services/ring_service.dart';

class Parowanie extends StatefulWidget{
    final RingService ringService;


    const Parowanie({super.key,required this.ringService,});

    @override
  State<Parowanie> createState() => _ParowanieState();
}

class _ParowanieState extends State<Parowanie> {


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
    final state = widget.ringService.currentState;

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