import 'dart:async';
import 'dart:ui';

class SimpleThrottler {
  bool _canExecute = true;
  Timer? _timer;

  void run({
    required VoidCallback action,
    Duration duration = const Duration(seconds: 1),
  }) {
    if (!_canExecute) return;
    _canExecute = false;
    action(); // 立即执行
    _timer?.cancel();
    _timer = Timer(duration, () {
      _canExecute = true;
    });
  }

  void dispose() {
    _timer?.cancel();
    _canExecute = true;
  }
}
