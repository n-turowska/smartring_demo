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
  void initState(){
    super.initState();

    widget.ringService.connectionState.listen((_){
      setState(() {});
    });
  }

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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Ring is disconected"), 
          ElevatedButton(
            onPressed: () async {
               try {
                  await widget.ringService.connect();
                } catch (_) {}
            },
            child: Text("Połącz"),
          ),]
        ),
      );
    }
    else if(state==RingConnectionState.scanning)
    {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Scanning"), CircularProgressIndicator(),]
        ),
      );
    }
    else if(state==RingConnectionState.connecting)
    {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Connecting"), CircularProgressIndicator(),]
        ),
      );
    }
    else if(state==RingConnectionState.connected)
    {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Ring is connected"),
          ElevatedButton(
            onPressed: () async {
              try {
                await widget.ringService.disconnect();
              } catch (_) {}
            },
            child: Text("Rozłącz")
          ),]
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("ERROR"),
          ElevatedButton(
            onPressed: () async {
              try {
                widget.ringService.connect();
              } catch (_) {}
            },
            child: Text("Połącz"),
          ),]
        ),
      );
    }
  }
}