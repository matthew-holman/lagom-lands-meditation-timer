import 'package:flutter/material.dart';

class AudioOption {
  final String name;
  final String filePath;
  final IconData icon;

  const AudioOption({
    required this.name,
    required this.filePath,
    required this.icon,
  });
}

// List of available audio files
const List<AudioOption> audioOptions = [
  AudioOption(
    name: "Running Water",
    filePath: "sounds/running_water.mp3",
    icon: Icons.water_drop,
  ),
  AudioOption(
    name: "Birds",
    filePath: "sounds/birds.mp3",
    icon: Icons.flutter_dash,
  ),
];