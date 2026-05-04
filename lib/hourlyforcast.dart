import 'package:flutter/material.dart';

class Hourlyforcast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;

  const Hourlyforcast({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,

      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(style: BorderStyle.solid, width: .25),
        ),

        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 10),

            Icon(icon, size: 32),

            const SizedBox(height: 10),

            Text('$temp°C'),
          ],
        ),
      ),
    );
  }
}
