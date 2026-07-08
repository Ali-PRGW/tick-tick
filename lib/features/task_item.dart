import 'package:flutter/material.dart';
import 'package:tiktik/core/constants/constants.dart';
import 'package:tiktik/data/data.dart';
import 'package:tiktik/features/my_check_box.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({super.key, required this.task});

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    Priority priority = widget.task.priority;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        setState(() {
          widget.task.isCompleted = !widget.task.isCompleted;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 84,
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            children: [
              MyCheckBox(value: widget.task.isCompleted),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.task.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
              Container(
                height: 84,
                width: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  color: priority == Priority.high
                      ? PriorityColors.high
                      : priority == Priority.normal
                      ? PriorityColors.normal
                      : PriorityColors.low,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
