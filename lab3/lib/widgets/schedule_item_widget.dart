import 'package:flutter/material.dart';
import '../models/schedule.dart';

class ScheduleItemWidget extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onDelete;

  ScheduleItemWidget({required this.schedule, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${schedule.subject} (${schedule.time})'),
        subtitle: Text('${schedule.teacher}, ${schedule.day}'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
