import 'package:flutter/material.dart';

class TaksCard extends StatefulWidget {
  final String task;
  final bool isDragging;
  const TaksCard({super.key, required this.task, this.isDragging = false});

  @override
  State<TaksCard> createState() => _TaksCardState();
}

class _TaksCardState extends State<TaksCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Говорим Flutter сохранить этот виджет

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      margin: const EdgeInsets.all(0),
      color: widget.isDragging ? Colors.blueAccent : Colors.white,
      child: SizedBox(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            widget.task,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
