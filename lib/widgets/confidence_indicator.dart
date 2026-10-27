import 'package:flutter/material.dart';

class ConfidenceIndicator extends StatelessWidget {
  final double confidence;
  const ConfidenceIndicator({super.key, required this.confidence});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.trending_up),
          const SizedBox(height: 4),
          Text(
            'Pewność przewidywania:',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.left,
          ),

          Text(
            ' ${confidence.toInt()}%',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            minHeight: 5,
            value: confidence / 100,
            backgroundColor: const Color.fromARGB(255, 226, 224, 224),
            color: Colors.green,
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
