import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  bool isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _fadeIn() async {
    for (double vol = 0.0; vol <= 1.0; vol += 0.1) {
      await _audioPlayer.setVolume(vol);
      await Future.delayed(const Duration(milliseconds: 50)); // Gradual fade-in
    }
  }

  Future<void> _fadeOut() async {
    for (double vol = 1.0; vol >= 0.0; vol -= 0.1) {
      await _audioPlayer.setVolume(vol);
      await Future.delayed(const Duration(milliseconds: 50)); // Gradual fade-out
    }
    await _audioPlayer.stop();
  }

  Future<void> _toggleAudio() async {
    if (isPlaying) {
      await _fadeOut(); // Fade-out before stopping
    } else {
      await _audioPlayer.setSource(AssetSource("sounds/running_water.mp3"));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Enable looping
      await _audioPlayer.setVolume(0.0); // Start silent
      await _audioPlayer.play(AssetSource("sounds/running_water.mp3"));
      await _fadeIn(); // Gradually increase volume
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _toggleAudio,
          child: Text(isPlaying ? "Stop" : "Start"),
        ),
      ),
    );
  }
}