import 'package:flutter/material.dart';
class HeaderLabel extends StatelessWidget {
  final String headerText;

  const HeaderLabel({super.key, required this.headerText});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        headerText,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          fontSize: 24,
        ),
      ),
    );
  }
}
