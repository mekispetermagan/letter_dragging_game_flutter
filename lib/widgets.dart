import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:letterdragging/rotating_hue_image.dart';

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
    final ColorScheme cs = Theme.of(context).colorScheme;
    return ReorderableDragStartListener(
      key: ValueKey(index),
      index: index,
      child: Card(
        color: cs.primaryContainer,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                color: cs.onPrimaryContainer,
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

class TitleText extends StatelessWidget {
  final String text;
  const TitleText({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        color: cs.onSurface,
      ),
    );
  }
}

class GemImage extends StatelessWidget {
  final double angleOffset;
  const GemImage({this.angleOffset = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return RotatingHueImage(
      image: Image(
        image: AssetImage(kIsWeb ? "images/gem.png" : "assets/images/gem.png"),
      ),
      startingAngle: angleOffset,
    );
  }
}

class ScoreArea extends StatelessWidget {
  final int score;
  const ScoreArea({required this.score});

  @override
  Widget build(BuildContext context) {
    return RotatingHue(
      rotationSpeed: 24,
      child: Wrap(
        children: [
          for (int i = 0; i < score; i++) GemImage(angleOffset: i * 60),
        ],
      ),
    );
  }
}

