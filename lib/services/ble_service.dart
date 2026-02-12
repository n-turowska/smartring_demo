import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {

  // singleton
  BleService._(); // Private constructor
  static final BleService instance = BleService._();

  /// Nasłuchiwanie stanu adaptera BLE (stream)
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  void listenToAdapterState() {
    _adapterStateSubscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print("Stan adaptera: $state");

      switch (state) {
        case BluetoothAdapterState.on:
          print("Bluetooth jest WŁĄCZONY");
          scanning();
          break;
        case BluetoothAdapterState.off:
          print("Bluetooth jest WYŁĄCZONY");
          break;
        case BluetoothAdapterState.unavailable:
          print("Bluetooth niedostępny na urządzeniu");
          break;
        case BluetoothAdapterState.unauthorized:
          print("Brak uprawnień do Bluetooth");
          break;
        default:
          print("Inny stan: $state");
      }
    });
  }

  // Scanowanie
  void scanning() async{
    print("zaczynamy skanowanie");
    var subscription = FlutterBluePlus.onScanResults.listen((results) {
        if (results.isNotEmpty) {
            ScanResult r = results.last; // the most recently found device
            print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
        }
    },
    onError: (e) => print(e),
    );

    FlutterBluePlus.cancelWhenScanComplete(subscription);

    

    await FlutterBluePlus.startScan(
    withNames:["Mira", "MIRA", "MiraRing"], 
    timeout: Duration(seconds:10));

    await FlutterBluePlus.isScanning.where((val) => val == false).first;
    print("scanowanie zakonczone");
  }


  /// Zwolnienie streama
  void dispose() {
    _adapterStateSubscription?.cancel();
  }
}