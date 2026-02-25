import 'package:flutter/material.dart';

class DeviceListTile extends StatelessWidget {
  final dynamic scanResult; 
  final VoidCallback onTap;
  final bool isConnecting;

  const DeviceListTile({
    super.key,
    required this.scanResult,
    required this.onTap,
    this.isConnecting = false,
  });

  @override
  Widget build(BuildContext context) {
    final deviceName = scanResult.advertisementData.advName.isEmpty
        ? "Nieznane urządzenie"
        : scanResult.advertisementData.advName;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: const Icon(Icons.bluetooth),
        title: Text(
          deviceName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("MAC: ${scanResult.device.remoteId}"),
            Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('RSSI: ${scanResult.rssi} dBm'),
                    if (scanResult.rssi >= -50)
                      Icon(Icons.signal_cellular_alt)
                    else if (scanResult.rssi >= -60)
                      Icon(Icons.signal_cellular_alt_2_bar)
                    else if (scanResult.rssi >= -70)
                      Icon(Icons.signal_cellular_alt_1_bar)
                    else
                      Icon(Icons.signal_cellular_off),],),
          ],
        ),
        trailing: isConnecting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}