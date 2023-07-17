import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

late AudioPlayer _player;

// final playStateProvider = StateNotifierProvider<PlayStateNotifier, bool>((ref) {
//   return PlayStateNotifier(false);
// });
final playStateProvider = ChangeNotifierProvider((ref) => PlayStateProvider());

class PlayStateProvider extends ChangeNotifier {
  PlayStateProvider() {
    _player = AudioPlayer()
      ..setLoopMode(LoopMode.all)
      ..playbackEventStream.listen(
        (event) {
          // // 再生中の時間を取得
          // final position = event.processingState == ProcessingState.idle
          //     ? Duration.zero
          //     : event.position;
          // logger.d("再生中の時間: $position");
        },
        onDone: () {
          // _player.seek(Duration.zero);
        },
        onError: (Object e, StackTrace stackTrace) {
//        state = false;
          _player.stop();
          notifyListeners();
        },
      );
  }

  bool get isPlaying => _player.playing;

  // void toggle() async {
  //   state = !state;
  //
  //   if (state) {
  //     final data = await rootBundle.load('assets/audio/pink_noise.mp3');
  //
  //     // 曲間で音が一瞬途切れてしまうのをどうにかしたい
  //     _player.setAudioSource(
  //       ConcatenatingAudioSource(
  //         useLazyPreparation: true,
  //         children: [
  //           AudioSource.uri(Uri.dataFromBytes(Uint8List.view(data.buffer))),
  //           // AudioSource.uri(Uri.dataFromBytes(Uint8List.view(data.buffer))),
  //         ],
  //       ),
  //       initialPosition: Duration.zero,
  //       preload: false,
  //     );
  //
  //     final session = await AudioSession.instance;
  //     await session.configure(const AudioSessionConfiguration.music());
  //
  //     await _player.play();
  //   } else {
  //     await _player.stop();
  //   }
  // }

  void toggle() async {
    if (_player.playing) {
      stop();
    } else {
      start();
    }
  }

  void start() async {
    final data = await rootBundle.load('assets/audio/pink_noise.mp3');

    _player.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: [
          AudioSource.uri(Uri.dataFromBytes(Uint8List.view(data.buffer))),
          // AudioSource.uri(Uri.dataFromBytes(Uint8List.view(data.buffer))),
        ],
      ),
      initialPosition: Duration.zero,
      preload: false,
    );

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    await _player.play();
    notifyListeners();
  }

  void stop() async {
    await _player.stop();
    notifyListeners();
  }
}
