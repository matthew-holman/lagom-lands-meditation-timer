import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/timer_controller.dart';
import '../managers/audio_manager.dart';
import '../widgets/timer_display.dart';
import '../state.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> with SingleTickerProviderStateMixin {
  late TimerController _timerController;
  late AudioManager _audioManager;
  bool isPlaying = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    _audioManager = AudioManager();
    _timerController = TimerController(
      remainingTime: 60,
      animationController: _animationController,
      onTimerComplete: _onTimerFinished,
    );
  }

  Future<void> _onTimerFinished() async {
    await _audioManager.playBeep();
    await _audioManager.fadeOut();
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> _toggleTimer(String selectedSound) async {
    if (isPlaying) {
      _timerController.stopTimer();
      await _audioManager.fadeOut();
    } else {
      await _audioManager.playSound(selectedSound);
      await _audioManager.fadeIn();
      _timerController.startTimer();
      _animationController.forward(from: 0.0);
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    _audioManager.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerDisplay(
              remainingTime: _timerController.remainingTime,
              animationController: _animationController,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _toggleTimer(appState.selectedSound),
              child: Text(isPlaying ? "Stop" : "Start"),
            ),
          ],
        ),
      ),
    );
  }
}