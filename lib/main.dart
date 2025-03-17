import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MeditationApp(),
    ),
  );
}
