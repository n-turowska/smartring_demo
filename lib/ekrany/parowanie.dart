import 'package:flutter/material.dart';
import '../services/ring_service.dart';
import '../services/ble_service.dart';

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

    BleService.instance.listenToAdapterState();
  }

  @override
  Widget build(BuildContext context) {
    int myIndex = 0;
    return Scaffold(
      
      body: _buildBody(),
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