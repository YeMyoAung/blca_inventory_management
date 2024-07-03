import 'dart:async';

class SearchController {
  final Duration duration;

  final StreamController<String> _streamController =
      StreamController.broadcast();

  Stream<String> get stream => _streamController.stream;

  SearchController({
    required this.duration,
  });

  Timer? _timer;

  void search(String text) {
    void callback() {
      _streamController.sink.add(text);
    }

    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  Future<void> dispose() async {
    _timer?.cancel();
    await _streamController.close();
  }
}
