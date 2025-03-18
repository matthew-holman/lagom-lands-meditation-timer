import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import '../state.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  bool isPlaying = false;
  bool _isFading = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _fadeIn() async {
    if (_isFading) return;
    _isFading = true;

    for (double vol = 0.0; vol <= 1.0; vol += 0.1) {
      await _audioPlayer.setVolume(vol);
      await Future.delayed(const Duration(milliseconds: 25));
    }

    setState(() {
      _isFading = false;
    });
  }

  Future<void> _fadeOut() async {
    if (_isFading) return;
    _isFading = true;

    for (double vol = 1.0; vol >= 0.0; vol -= 0.1) {
      await _audioPlayer.setVolume(vol);
      await Future.delayed(const Duration(milliseconds: 25));
    }

    await _audioPlayer.stop();
    setState(() {
      _isFading = false;
    });
  }

  Future<void> _toggleAudio(String selectedSound) async {
    if (_isFading) return; // Prevent multiple presses

    if (isPlaying) {
      await _fadeOut();
    } else {
      await _audioPlayer.setSource(AssetSource(selectedSound));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(0.0);
      await _audioPlayer.play(AssetSource(selectedSound));
      await _fadeIn();
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
    final appState = Provider.of<AppState>(context);
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _isFading ? null : () => _toggleAudio(appState.selectedSound),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isFading ? Colors.grey : theme.onPrimary,
          ),
          child: Text(isPlaying ? "Stop" : "Start"),
        ),
      ),
    );
  }
}