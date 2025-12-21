import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:letterdragging/countdown_widgets.dart';
import 'package:letterdragging/widgets.dart';
import 'package:letterdragging/countdown_logic.dart' show CountdownStatus;


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
            TitleText(
              text: "Mixed Letters",
            ),
            Image(
              image: AssetImage("assets/images/cover_image.png"),
              width: 300,
            ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final option in options)
              PrimaryActionButton(
                text: option,
                onPressed: (o != null) ? () => o(option) : null
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseScreen extends StatelessWidget {
  final void Function(int, int)? onReorder;
  final VoidCallback onPass;
  final String language;
  final String category;
  final String difficulty;
  final int rounds;
  final String _word;
  final CountdownStatus countdownStatus;
  final String? debugMessage;
  const ExerciseScreen({
    required this.onReorder,
    required this.onPass,
    required String? word,
    required this.language,
    required this.category,
    required this.difficulty,
    required this.rounds,
    required this.countdownStatus,
    this.debugMessage,
    super.key
  }) : _word = word ?? "";

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final oR = onReorder;
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 36,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (kDebugMode) Text(debugMessage ?? ""),

              Text(
                "$category: $difficulty",
                style: TextStyle(
                  fontSize: 24,
                  color: cs.onSurface,
                ),
              ),

              SizedBox(
                height: 48,
                width: 52.0*_word.length,
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
                  children: <Widget>[
                    for (int i=0; i<_word.length; i++)
                    LetterCard(index: i, letter: _word[i], key: ValueKey(i))
                  ],
                ),
              ),

              PrimaryActionButton(text: "Pass", onPressed: onPass),

              CountdownTimer(
                status: countdownStatus,
                baseSize: 30
              ),

              ScoreArea(score: rounds-1,),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final VoidCallback? onRestart;
  final int rounds;
  const ResultScreen({
    required this.onRestart,
    required this.rounds,
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
            TitleText(text: "Congratulations!\n"
            "You have collected $rounds gems."),
            PrimaryActionButton(
              text: "One more round?",
              onPressed: onRestart
            ),
            ScoreArea(score: rounds-1,),
          ],
        ),
      ),
    );
  }
}
