import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerProvider = ChangeNotifierProvider((ref) => TimerProvider());

class TimerProvider extends ChangeNotifier {
  Timer? _timer;
  Duration _selectedTime = const Duration(seconds: 0);
  Duration _remainingTime = const Duration(seconds: 0);

  Duration get selectedTime => _selectedTime;

  // set selectedTime(Duration value) {
  //   _selectedTime = value;
  //   _remainingTime = value;
  //   notifyListeners();
  // }

  set selectedTime(Duration? value) {
    if (value != null && value.inSeconds > 0) {
      _selectedTime = value;
      _remainingTime = value;
      notifyListeners();
    }
  }

  Duration get remainingTime => _remainingTime;

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds == 0) {
        stopTimer();
      } else {
        _remainingTime -= const Duration(seconds: 1);
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _remainingTime = const Duration(seconds: 0);
    notifyListeners();
  }
}
