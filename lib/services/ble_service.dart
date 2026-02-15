import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {

  // singleton
  BleService._(); // Private constructor
  static final BleService instance = BleService._();

  /// Nasłuchiwanie stanu adaptera BLE (stream)
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  void listenToAdapterState() async{
    // first, check if bluetooth is supported by your hardware
    // Note: The platform is initialized on the first call to any FlutterBluePlus method.
    if (await FlutterBluePlus.isSupported == false) {
        print("Bluetooth not supported by this device");
        return;
    }

    // handle bluetooth on & off
    // note: for iOS the initial state is typically BluetoothAdapterState.unknown
    // note: if you have permissions issues you will get stuck at BluetoothAdapterState.unauthorized
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
        print(state);
        if (state == BluetoothAdapterState.on) {
            print("Bluetooth włączony");
          scanning();
        } else {
            print("Bluetooth wyłączony");
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