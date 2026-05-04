import 'package:flutter/material.dart';

class Addtionalinfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const Addtionalinfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32),

        const SizedBox(height: 6),

        Text(label),

        const SizedBox(height: 10),

        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
