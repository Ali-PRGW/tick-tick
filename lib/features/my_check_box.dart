import 'package:flutter/material.dart';

class MyCheckBox extends StatelessWidget {
  final bool value;

  const MyCheckBox({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: !value ? Border.all(color: Colors.grey, width: 1.7) : null,
          color: value ? Theme.of(context).colorScheme.primary : null,
        ),
        child: value
            ? Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 18,
              )
            : null,
      ),
    );
  }
}