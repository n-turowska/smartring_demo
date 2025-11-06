// widgets/common/main_shape.dart

import 'package:flutter/material.dart';

/// Reusable neumorphic container widget
///
/// Creates a styled container with:
/// - Rounded corners
/// - Soft shadows (neumorphic design)
/// - Customizable color and text
///
/// Used throughout the app to display metrics in a consistent style.
///
/// Example usage:
/// ```dart
/// MainShape(
///   kolor: Color.fromARGB(255, 130, 167, 197),
///   nazwa: 'Steps: 5607',
/// )
/// ```
class MainShape extends StatelessWidget {
  /// Background color of the container
  final Color kolor;

  /// Text to display in the center
  final String nazwa;

  const MainShape({
    super.key,
    this.kolor = Colors.lightBlueAccent,
    required this.nazwa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: kolor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            offset: const Offset(4.0, 4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4.0, -4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        nazwa,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.white),
      ),
    );
  }
}
