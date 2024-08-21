import 'package:draglist_example/screens/task_board_screen/widgets/task_card.dart';
import 'package:flutter/material.dart';

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  Map<String, int?> dragPositionIndex = {};
  final double _scrollSpeed = 10.0;
  final ScrollController _scrollController = ScrollController();
  final List<List<String>> columns = [
    ['Task 1', 'Task 2'],
    ['Task 3', 'Task 4'],
    ['Task 5', 'Task 6'],
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
            onMove: (details) {
              setState(() {
                dragPositionIndex['column'] = columnIndex;
              });
            },
            onAcceptWithDetails: (task) =>
                dropToColumn(task: task, columnIndex: columnIndex),
            builder: (context, candidateData, rejectedData) {
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                      color: columnIndex == dragPositionIndex['column']
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Column ${columnIndex + 1}',
                            style: const TextStyle(fontSize: 18)),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: columns[columnIndex].length,
                            itemBuilder: (context, index) {
                              final column = columns[columnIndex];
                              final task = column[index];
                              return Column(
                                children: [
                                  DragTarget<String>(
                                      onMove: (details) {
                                        setState(() {
                                          dragPositionIndex['column'] =
                                              columnIndex;
                                          dragPositionIndex['task'] = index;
                                        });
                                      },
                                      onAcceptWithDetails: (task) =>
                                          dropToColumn(
                                              task: task,
                                              columnIndex: columnIndex),
                                      builder: (context, candidateData,
                                          rejectedData) {
                                        return Container(
                                            height: dragPositionIndex[
                                                            'column'] ==
                                                        columnIndex &&
                                                    dragPositionIndex['task'] ==
                                                        index
                                                ? 40
                                                : 10);
                                      }),
                                  Draggable<String>(
                                    data: task,
                                    feedback: Material(
                                      color: Colors.transparent,
                                      child: TaksCard(
                                          task: task, isDragging: true),
                                    ),
                                    onDragEnd: (details) {
                                      setState(() {
                                        dragPositionIndex['column'] = null;
                                      });
                                    },
                                    onDragUpdate: (details) {
                                      debugPrint('${details.globalPosition}');
                                      debugPrint('$width');
                                      if (details.globalPosition.dx >
                                          width - scrollThreshold) {
                                        _scrollRight();
                                      }
                                      if (details.globalPosition.dx <
                                          scrollThreshold) {
                                        _scrollLeft();
                                      }
                                    },
                                    child: TaksCard(task: task),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void dropToColumn(
      {required DragTargetDetails<String> task, required int columnIndex}) {
    setState(() {
      // Remove the task from its previous column
      for (var column in columns) {
        column.remove(task.data);
      }
      // Add the task to the new column
      columns[columnIndex].add(task.data);
    });
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
