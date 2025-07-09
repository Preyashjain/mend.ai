import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/sessions'),
              child: const Text("Start Session"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/reflections'),
              child: const Text("Reflections"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/scores'),
              child: const Text("Scores"),
            ),
          ],
        ),
      ),
    );
  }
}
