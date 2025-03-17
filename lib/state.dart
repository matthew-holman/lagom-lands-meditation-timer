import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int timerDuration = 25 * 60; // Default 25 min
  bool isRunning = false;
  String selectedSound = "bell"; // Default sound

  void setTimerDuration(int seconds) {
    timerDuration = seconds;
    notifyListeners();
  }

  void toggleTimer(bool running) {
    isRunning = running;
    notifyListeners();
  }

  void setSelectedSound(String sound) {
    selectedSound = sound;
    notifyListeners();
  }
}