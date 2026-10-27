import 'package:flutter/material.dart';

class ConfidenceIndicator extends StatelessWidget {
  final double confidence;
  const ConfidenceIndicator({super.key, required this.confidence});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Pewność wzrasta z każdym cyklem i regularnością",
      child: Column(
        children: [
          Text('Pewność: ${confidence.toInt()}%'),
          LinearProgressIndicator(
            value: confidence / 100,
            backgroundColor: Colors.grey,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
