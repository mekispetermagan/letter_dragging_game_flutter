import 'package:flutter/material.dart';

class PrimaryActionButton extends StatelessWidget {
  final String text;
  final String nullText;
  final VoidCallback? onPressed;
  final double fontSize;
  const PrimaryActionButton({
    required this.text,
    required this.onPressed,
    this.fontSize=24,
    nullText,
    super.key,
  }) : nullText = nullText ?? text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          cs.primaryContainer,
        ),
        foregroundColor: WidgetStatePropertyAll(
          cs.onPrimaryContainer,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          onPressed != null ? text : nullText,
          style: TextStyle(
            fontSize: fontSize,
          ),
          ),
      ),
    );
  }
}

class LetterCard extends StatelessWidget {
  final String letter;
    final int index;
  const LetterCard({
    required this.letter,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      key: ValueKey(index),
      index: index,
      child: Card(
        color: Colors.purpleAccent[700],
        child: SizedBox(
          width: 42,
          height: 42,
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
