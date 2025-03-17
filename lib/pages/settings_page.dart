import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../constants/audio_files.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Select Sound:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...audioOptions.map((option) {
            return RadioListTile<String>(
              title: Row(
                children: [
                  Icon(option.icon, color: Colors.black54),
                  const SizedBox(width: 10),
                  Text(option.name),
                ],
              ),
              value: option.filePath,
              groupValue: appState.selectedSound,
              onChanged: (value) {
                if (value != null) {
                  appState.setSelectedSound(value);
                }
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}