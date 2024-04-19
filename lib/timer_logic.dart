import 'dart:async';
import 'package:intl/intl.dart';

class TimerLogic {
  late Timer _timer;
  int _secondsElapsed = 0;
  bool _isRunning = false;
  final List<String> _timeHistory = [];

  static final _currentTimeController = StreamController<String>.broadcast();
  static final _timeHistoryController = StreamController<List<String>>.broadcast();
  static final _isRunningController = StreamController<bool>.broadcast();

  Stream<String> get currentTimeStream => _currentTimeController.stream;
  Stream<List<String>> get timeHistoryStream => _timeHistoryController.stream;
  Stream<bool> get isRunningStream => _isRunningController.stream;

  TimerLogic() {
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    if (_isRunning) {
      _secondsElapsed++;
      _updateCurrentTime();
    }
  }

  void _updateCurrentTime() {
    const int secondsPerHour = 3600;
    const int secondsPerMinute = 60;

    final int hours = _secondsElapsed ~/ secondsPerHour;
    final int minutes = (_secondsElapsed % secondsPerHour) ~/ secondsPerMinute;
    final int seconds = _secondsElapsed % secondsPerMinute;

    _currentTimeController.add('${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}');
  }

  void startStopTimer() {
    if (!_isRunning) {
      _timeHistory.add(_getCurrentTime());
    } else {
      _timeHistory[_timeHistory.length - 1] += ' - ${_getCurrentTime()}';
    }
    _timeHistoryController.add(_timeHistory);

    _isRunning = !_isRunning;
    _isRunningController.add(_isRunning);
  }

  void resetTimer() {
    _secondsElapsed = 0;
    _isRunning = false;
    _timeHistory.clear();
    _updateCurrentTime();
    _timeHistoryController.add([]);
    _isRunningController.add(false);
  }

String _getCurrentTime() {
  final now = DateTime.now();
  final formattedDate = DateFormat('dd/MM HH:mm').format(now);
  return formattedDate;
}

  void dispose() {
    _timer.cancel();
    _currentTimeController.close();
    _timeHistoryController.close();
    _isRunningController.close();
  }
}
