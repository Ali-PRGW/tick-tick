import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tiktik/core/constants/constants.dart';
import 'package:tiktik/data/data.dart';
import 'package:tiktik/main.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity task;
  const EditTaskScreen({super.key,required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller = TextEditingController(text: widget.task.name);
  Priority selectedPriority = Priority.normal;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveTask() {
    widget.task.name = _controller.text.trim();
    widget.task.priority = selectedPriority;

    if (widget.task.isInBox) {
      widget.task.save();
    } else {
      final Box<TaskEntity> box = Hive.box<TaskEntity>(taskBoxName);
      box.add(widget.task);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: context.isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text("Edit Task"),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _saveTask,
          icon: const Icon(Icons.check, size: 22),
          label: const Text("Save Changes"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              PriorityCheckBox(
                selectedPriority: selectedPriority,
                onChanged: (priority) {
                  setState(() {
                    selectedPriority = priority;
                  });
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TextField(
                  controller: _controller,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    labelText: "Add a task for today...",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final Priority selectedPriority;
  final ValueChanged<Priority> onChanged;

  const PriorityCheckBox({
    super.key,
    required this.selectedPriority,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildItem(
          context,
          label: 'High',
          color: PriorityColors.high,
          priority: Priority.high,
        ),
        _buildItem(
          context,
          label: 'Normal',
          color: PriorityColors.normal,
          priority: Priority.normal,
        ),
        _buildItem(
          context,
          label: 'Low',
          color: PriorityColors.low,
          priority: Priority.low,
        ),
      ],
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required String label,
    required Color color,
    required Priority priority,
  }) {
    final bool isSelected = selectedPriority == priority;

    return InkWell(
      onTap: () => onChanged(priority),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  width: 2,
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Text(label),
            const SizedBox(width: 8),
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.circle, color: color, size: 20),
                if (isSelected)
                  Icon(
                    Icons.check,
                    size: 12,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
