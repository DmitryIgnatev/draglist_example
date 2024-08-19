import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TaskBoardScreen(),
    );
  }
}

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  final double _scrollSpeed = 10.0;
  final ScrollController _scrollController = ScrollController();
  final List<List<String>> columns = [
    ['Task 1', 'Task 2'],
    ['Task 3', 'Task 4'],
    ['Task 5', 'Task 6'],
    // Add more columns as needed
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scrollThreshold = width / 6;
    return Scaffold(
      appBar: AppBar(title: const Text("Task Board")),
      body: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: columns.length,
        itemBuilder: (context, columnIndex) {
          return DragTarget<String>(
            onAcceptWithDetails: (task) {
              setState(() {
                // Remove the task from its previous column
                for (var column in columns) {
                  column.remove(task.data);
                }
                // Add the task to the new column
                columns[columnIndex].add(task.data);
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Column ${columnIndex + 1}',
                          style: const TextStyle(fontSize: 18)),
                      for (var task in columns[columnIndex])
                        Draggable<String>(
                          data: task,
                          feedback: Material(
                            child: TaksCard(task: task, isDragging: true),
                          ),
                          onDragUpdate: (details) {
                            debugPrint('${details.globalPosition}');
                            debugPrint('$width');
                            if (details.globalPosition.dx >
                                width - scrollThreshold) {
                              _scrollRight();
                            }
                            if (details.globalPosition.dx < scrollThreshold) {
                              _scrollLeft();
                            }
                          },
                          childWhenDragging: Container(),
                          child: TaksCard(task: task),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _scrollRight() {
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        _scrollController.position.pixels + _scrollSpeed,
        duration: const Duration(milliseconds: 50),
        curve: Curves.linear,
      );
    }
  }

  void _scrollLeft() {
    if (_scrollController.position.pixels >
        _scrollController.position.minScrollExtent) {
      _scrollController.animateTo(
        _scrollController.position.pixels - _scrollSpeed,
        duration: const Duration(milliseconds: 50),
        curve: Curves.linear,
      );
    }
  }
}

class TaksCard extends StatelessWidget {
  final String task;
  final bool isDragging;
  const TaksCard({super.key, required this.task, this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    return Card(
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
