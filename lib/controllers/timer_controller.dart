import 'dart:async';
import 'package:flutter/material.dart';

class TimerController extends ChangeNotifier {
  int remainingTime;
  Timer? _timer;
  final AnimationController animationController;
  final VoidCallback onTimerComplete; // Callback when timer ends

  TimerController({
    required this.remainingTime,
    required this.animationController,
    required this.onTimerComplete,
  });

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime <= 0) {
        timer.cancel();
        onTimerComplete();
      } else {
        remainingTime--;
        animationController.value = 1.0 - (remainingTime / 60.0);
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    remainingTime = 60; // Reset
    animationController.reset();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}