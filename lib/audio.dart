import 'package:audioplayers/audioplayers.dart';

class Player {
  final String assetPath;
  final AudioPlayer _player = AudioPlayer()
    ..setReleaseMode(ReleaseMode.stop);
  Player({this.assetPath = "audio"});

  Future<void> _play(String name) async {
    await _player.stop();
    _player.play(AssetSource("$assetPath/$name"));
  }

  void correct() => _play("correct.mp3");

  void fanfare() => _play("fanfare.mp3");

  void pop() => _play("pop.wav");
}

