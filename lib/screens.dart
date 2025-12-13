import 'package:flutter/material.dart';
import 'package:letterdragging/widgets.dart';


class TitleScreen extends StatelessWidget {
  final VoidCallback? onStart;
  const TitleScreen({
    required this.onStart,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Mixed Letters"),
            PrimaryActionButton(
              text: "Start",
              onPressed: onStart
            ),
          ],
        ),
      ),
    );
  }
}

class SelectScreen extends StatelessWidget {
  final void Function(String)? onSelect;
  final List<String> options;
  const SelectScreen({
    required this.onSelect,
    required this.options,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final o = onSelect;
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            for (final option in options)
            PrimaryActionButton(
              text: option,
              onPressed: (o != null) ? () => o(option) : null
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseScreen extends StatelessWidget {
  final void Function(int, int)? onReorder;
  final String _word;
  const ExerciseScreen({
    required this.onReorder,
    required word,
    super.key
  }) : _word = word ?? "";

  @override
  Widget build(BuildContext context) {
    final oR = onReorder;
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 48,
              child: ReorderableListView(
                buildDefaultDragHandles: false,
                scrollDirection: Axis.horizontal,
                onReorder: (oR != null)
                  ? (int i, int j) => oR(i, j)
                  : (int i, int j) {},
                proxyDecorator: (Widget child, int index, Animation<double> animation) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Material(
                      elevation: 6,
                      child: child,
                    ),
                  );
                },
                children: [
                  for (int i=0; i<_word.length; i++)
                  LetterCard(index: i, letter: _word[i], key: ValueKey(i))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final VoidCallback? onRestart;
  const ResultScreen({
    required this.onRestart,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("The game has ended."),
            PrimaryActionButton(
              text: "One more?",
              onPressed: onRestart
            ),
          ],
        ),
      ),
    );
  }
}
