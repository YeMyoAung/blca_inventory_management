class BlocBaseState {
  final DateTime _time;

  BlocBaseState() : _time = DateTime.now();

  @override
  bool operator ==(covariant BlocBaseState other) {
    return other._time.toIso8601String() == _time.toIso8601String() &&
        other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => _time.hashCode & runtimeType.hashCode;
}
