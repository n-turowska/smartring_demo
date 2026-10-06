import 'package:flutter/material.dart';
import 'package:smartring_demo/models/symptom.dart';

class IntensitySlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const IntensitySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Intensywność:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: value.toString(),
          activeColor: const Color.fromARGB(255, 235, 53, 183),
          inactiveColor: Colors.grey.shade300,
          thumbColor: const Color.fromARGB(255, 235, 53, 183),
          onChanged: (newValue) => onChanged(newValue.toInt()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final level = index + 1;
            return Text(
              level.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: value == level
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: value >= level
                    ? const Color.fromARGB(255, 235, 53, 183)
                    : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}
