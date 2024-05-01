class BasicState {
  final DateTime _time;

  BasicState() : _time = DateTime.now();

  @override
  bool operator ==(covariant BasicState other) {
    return other._time.toIso8601String() == _time.toIso8601String() &&
        other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => _time.hashCode & runtimeType.hashCode;
}
