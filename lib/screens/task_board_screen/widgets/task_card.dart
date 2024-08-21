import 'package:flutter/material.dart';

class TaksCard extends StatelessWidget {
  final String task;
  final bool isDragging;
  const TaksCard({super.key, required this.task, this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      color: isDragging ? Colors.blueAccent : Colors.white,
      child: SizedBox(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            task,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
