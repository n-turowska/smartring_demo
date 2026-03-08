import 'package:flutter/material.dart';
import '/services/ble_service.dart';
import '../pairing/widgets/radar_animation.dart';
import "../pairing/widgets/device_list_tile.dart";
import "../pairing/pairing_screen.dart";


class DeviceDiscoveryScreen extends StatefulWidget{
  
    const DeviceDiscoveryScreen({super.key});

    @override
  State<DeviceDiscoveryScreen> createState() => _DeviceDiscoveryScreenState();
}

class _DeviceDiscoveryScreenState extends State<DeviceDiscoveryScreen> {
  int myIndex = 0;
  final BleService bleService = BleService.instance;

  @override
  void initState(){
    super.initState();

    bleService.listenToAdapterState();

    bleService.scanningState.listen((data){
      setState(() {});
    });
    bleService.devicesState.listen((data){
      setState(() {});
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
            'Mój Ring',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
          if (index == 0) {
            return;
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
    final state = bleService.currentState;

    return RefreshIndicator(
      onRefresh: () async{
        if(!bleService.isScanning){
          await bleService.scanning();
        }
      },
        child: ListView(
          //spacing: 10.0,
          //mainAxisAlignment: MainAxisAlignment.center,
          padding: const EdgeInsets.all(8),
          children: [ 
            const SizedBox(height: 20),
            if (bleService.isScanning)
              Center(
                child: Column(
                  children: [
                    RadarAnimation(
                      isScanning: bleService.isScanning,
                      size: 200,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Skanowanie urządzeń...",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(!bleService.isScanning){
                  bleService.scanning();
                }
                else{
                  bleService.stopScan();
                }
              },
              child: Text(state ? "anuluj" : "skanuj"),
            ),
            Text(bleService.allResults.isEmpty ? "Nie znaleziono urządzeń" : "Znalezione urządzenia:"),
            for(var r in bleService.allResults)
              DeviceListTile(
                scanResult: r,
                onTap: () async {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Łączenie z urządzeniem..."),
                    ),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PairingScreen(),
                    ),
                  );

                  await bleService.connect(r.device);
                },
              ),
          ]
        ),
    );
  }
}