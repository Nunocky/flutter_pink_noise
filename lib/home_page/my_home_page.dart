import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './play_state_provider.dart';
import './play_button.dart';

/// ホームページ
class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPlaying = ref.watch(playStateProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Pink Noise"),
      ),
      body: Center(
        child: PlayButton(
          isPlaying: isPlaying,
          onClicked: () {
            // 再生状態を反転させる
            ref.read(playStateProvider.notifier).toggle();
          },
        ),
      ),
    );
  }
}
