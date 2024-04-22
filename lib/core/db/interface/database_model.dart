import 'dart:convert';

/// Model
abstract class DatabaseModel {
  final int id;
  const DatabaseModel({required this.id});
  Map<String, dynamic> toJson();

  @override
  operator ==(covariant DatabaseModel other) {
    return other.id == id && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => id & runtimeType.hashCode;

  @override
  String toString() {
    return json.encode(toJson());
  }
}

class Result<T> {
  final T? _result;
  final Error? _exception;

  const Result({T? result, Error? exception})
      : _exception = exception,
        _result = result,
        assert((result == null && exception != null) ||
            (result == null && exception == null) ||
            (result != null && exception == null));

  bool get hasError => _exception != null;

  T? get result {
    assert(_exception == null);
    return _result;
  }

  Error? get exception {
    assert(_result == null);
    return _exception;
  }

  @override
  String toString() {
    if (hasError) {
      return exception?.message ?? "Unknown Error Occour";
    }
    return result?.toString() ?? "NULL";
  }
}

class Error implements Exception {
  final String message;
  final StackTrace? stackTrace;
  Error(this.message, [this.stackTrace]);
}

/// How to create or udpate
abstract class DatabaseParamModel {
  const DatabaseParamModel();
  Map<String, dynamic> toCreate();
  Map<String, dynamic> toUpdate();
}
