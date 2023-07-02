import 'package:flutter/material.dart';
import './play_button.dart';

/// ホームページ
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Pink Noise"),
      ),
      body: Center(
        child: PlayButton(
          isPlaying: isPlaying,
          onClicked: () {
            setState(() {
              isPlaying = !isPlaying;
            });
          },
        ),
      ),
    );
  }
}
