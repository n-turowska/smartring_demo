import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {

  /// Nasłuchiwanie stanu adaptera BLE (stream)
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  void listenToAdapterState() {
    _adapterStateSubscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print("Stan adaptera: $state");

      switch (state) {
        case BluetoothAdapterState.on:
          print("Bluetooth jest WŁĄCZONY");
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

  /// Zwolnienie streama
  void dispose() {
    _adapterStateSubscription?.cancel();
  }
}