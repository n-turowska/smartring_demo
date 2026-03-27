import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

enum PairingState {
  /// No process running
  idle,

  /// Connecting to device
  connecting,

  /// Discovering device services
  discoveringServices,

  /// Pairing with device
  pairing,

  /// Pairing successful
  success,

  /// Pairing failed
  faild,
  
}


class BleService {
  var isScanning = false;
  PairingState pairingState = PairingState.idle;
  List<ScanResult> allResults = [];

  // singleton
  BleService._(); // Private constructor
  static final BleService instance = BleService._();

  // ============ STREAMS ============
  final _controler = StreamController<bool>.broadcast();
  Stream<bool> get scanningState => _controler.stream;

  final _deviceControler = StreamController<ScanResult>.broadcast();
  Stream<ScanResult> get devicesState => _deviceControler.stream;

  bool get currentState => isScanning;

  //pairing state stream
  final _pairingController = StreamController<PairingState>.broadcast();
  Stream<PairingState> get pairingStateStream => _pairingController.stream;

  PairingState get currentPairingState => pairingState;

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
  Future<void> scanning() async{
    isScanning = true;
    _controler.add(true);
    // listen to scan results
    // Note: `onScanResults` clears the results between scans. You should use
    //  `scanResults` if you want the current scan results *or* the results from the previous scan.
    var subscription = FlutterBluePlus.onScanResults.listen((results) {
      var sortedResults = List<ScanResult>.from(results)
      ..sort((a, b) => b.rssi.compareTo(a.rssi));

      allResults = sortedResults;

            if (results.isNotEmpty) {
                _deviceControler.add(results.last);
                ScanResult r = results.last; // the most recently found device
                print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
            }
        },
        onError: (e) => print(e),
    );

    // cleanup: cancel subscription when scanning stops
    FlutterBluePlus.cancelWhenScanComplete(subscription);

    // Wait for Bluetooth enabled & permission granted
    // In your real app you should use `FlutterBluePlus.adapterState.listen` to handle all states
    await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;
    requestPermissions();

    // Start scanning w/ timeout
    // Optional: use `stopScan()` as an alternative to timeout
    await FlutterBluePlus.startScan(
      //withServices:[Guid("180D")], // match any of the specified services
      //withNames:["Test advertising raw data", "Mi Smart Band 5"], // *or* any of the specified names
      timeout: Duration(seconds:10));

    // wait for scanning to stop
    await FlutterBluePlus.isScanning.where((val) => val == false).first;

    print("  ");
    print("Znalezione urządzenia:");
    for(ScanResult r in allResults)
    {
      print('${r.device.remoteId}: "${r.advertisementData.advName}"');
    }
    isScanning = false;
    _controler.add(false);
  }

  Future<void> connect(BluetoothDevice device) async {
    pairingState = PairingState.connecting;
    _pairingController.add(PairingState.connecting);
    // listen for disconnection
    var subscription = device.connectionState.listen((BluetoothConnectionState state) async {
        if (state == BluetoothConnectionState.disconnected) {
            // 1. typically, start a periodic timer that tries to 
            //    reconnect, or just call connect() again right now
            // 2. you must always re-discover services after disconnection!
            print("${device.disconnectReason?.code} ${device.disconnectReason?.description}");
        }
    });

    // cleanup: cancel subscription when disconnected
    //   - [delayed] This option is only meant for `connectionState` subscriptions.  
    //     When `true`, we cancel after a small delay. This ensures the `connectionState` 
    //     listener receives the `disconnected` event.
    //   - [next] if true, the the stream will be canceled only on the *next* disconnection,
    //     not the current disconnection. This is useful if you setup your subscriptions
    //     before you connect.
    device.cancelWhenDisconnected(subscription, delayed:true, next:true);

    // Connect to the device
    await device.connect(license: License.free);

    //DISCOVER SERVICES
    // Note: You must call discoverServices after every re-connection!
    List<BluetoothService> services = await device.discoverServices();
    pairingState = PairingState.discoveringServices;
    _pairingController.add(PairingState.discoveringServices);
    services.forEach((service) {
        print(service);
    });

    await Future.delayed(const Duration(seconds: 10));
    await device.disconnect();
  }

  void stopScan () async{
    await FlutterBluePlus.stopScan();
  }
  
  
  Future<void> requestPermissions() async {
    // Poproś o wszystkie potrzebne uprawnienia
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }


  /// Zwolnienie streama
  void dispose() {
    _adapterStateSubscription?.cancel();
  }
}