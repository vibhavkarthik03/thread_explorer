import 'package:flutter/material.dart';
import 'package:thread_explorer/features/threads/presentation/screens/threads_screen.dart';

void main() {
  runApp(const ThreadExplorer());
}

class ThreadExplorer extends StatelessWidget {
  const ThreadExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ThreadScreen(),
    );
  }
}
