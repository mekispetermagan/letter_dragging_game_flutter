import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:letterdragging/state_controller.dart';
import 'package:letterdragging/screens.dart';


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlueAccent,
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final StateController _controller = StateController();
  late final Ticker _ticker;
  HomePageState();

  @override
  void initState() {
    _controller.state.addListener(_onStateChanged);
    _ticker = createTicker(
      (elapsed) => setState(() => _controller.onTick(elapsed.inMilliseconds))
    )..start();
    super.initState();
  }

  @override
  void dispose() {
    _controller.state.removeListener(_onStateChanged);
    _ticker.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return switch (_controller.state.value) {
      AppState.loading => TitleScreen(
        onStart: null
      ),

      AppState.title => TitleScreen(
        onStart: _controller.onStart
      ),

      AppState.languageSelect => SelectScreen(
        onSelect: _controller.onLanguageSelect,
        options: _controller.languages
      ),

      AppState.categorySelect => SelectScreen(
        onSelect: _controller.onCategorySelect,
        options: _controller.categories
      ),

      AppState.difficultySelect => SelectScreen(
        onSelect: _controller.onDifficultySelect,
        options: _controller.difficulties
      ),

      AppState.solving => ExerciseScreen(
        onReorder: _controller.onReorder,
        onPass: _controller.nextRound,
        language: _controller.language,
        category: _controller.category,
        difficulty: _controller.difficulty,
        rounds: _controller.rounds,
        word: _controller.currentWord,
        countdownStatus: _controller.countdownStatus,
        debugMessage: "",
      ),

      AppState.feedbackCorrect => ExerciseScreen(
        onReorder: null,
        onPass: _controller.nextRound,
        language: _controller.language,
        category: _controller.category,
        difficulty: _controller.difficulty,
        rounds: _controller.rounds,
        word: _controller.currentWord,
        countdownStatus: _controller.countdownStatus,
        debugMessage: "",
      ),

      AppState.feedbackIncorrect => ExerciseScreen(
        onReorder: null,
        onPass: _controller.nextRound,
        language: _controller.language,
        category: _controller.category,
        difficulty: _controller.difficulty,
        rounds: _controller.rounds,
        word: _controller.currentWord,
        countdownStatus: _controller.countdownStatus,
        debugMessage: "",
      ),

      AppState.result => ResultScreen(
        onRestart: _controller.onRestart,
        rounds: _controller.rounds,
      ),
    };
  }
}

void main() {
  runApp(const MainApp());
}
