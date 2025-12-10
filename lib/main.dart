import 'package:flutter/material.dart';
import 'package:letterdragging/state_controller.dart';



class LetterCard extends StatelessWidget {
  final String letter;
    final int id;
  const LetterCard({
    required this.letter,
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
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



class HomePageState extends State<HomePage> {
  String _debugMessage = "";
  final StateController _controller = StateController();
  HomePageState();

  @override
  void initState() {
    _controller.state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _controller.state.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() => setState(() {});

  void _onReorder(int i, int j) => setState(() => _debugMessage = "i: $i, j: $j");

  @override
  Widget build(BuildContext context) {
    final String word = "GRANDMA";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "grandma $_debugMessage",
          style: TextStyle(color: Colors.black,),
        ),
      ),
      body: Center(
        child: SizedBox(
          height: 48,
          child: ReorderableListView(
            buildDefaultDragHandles: false,
            scrollDirection: Axis.horizontal,
            onReorder: (int i, int j) => _onReorder(i, j),
            proxyDecorator: (Widget child, int index, Animation<double> animation) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16), // match your Card radius
                child: Material(
                  elevation: 6, // optional, for the lifted look
                  child: child,
                ),
              );
            },
            children: [ for (int i=0; i<word.length; i++)
              ReorderableDragStartListener(
                key: ValueKey(i),
                index: i,
                child: LetterCard(id: i, letter: word[i]),
              )

            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MainApp());
}
