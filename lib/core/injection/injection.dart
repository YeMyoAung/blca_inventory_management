abstract class _ContainerValue<T> {
  ///will be overrride
  get value;
  final Function(T)? dispose;
  final bool autoDispose;

  const _ContainerValue(this.dispose, this.autoDispose);
}

/// actual value
class _Value<T> extends _ContainerValue<T> {
  @override
  final T value;

  const _Value(
    this.value,
    Function(T)? dispose,
    bool autoDispose,
  ) : super(dispose, autoDispose);
}

/// function
class _LazyValue<T> extends _ContainerValue<T> {
  @override
  final T Function() value;

  const _LazyValue(
    this.value,
    Function(T)? dispose,
    bool autoDispose,
  ) : super(dispose, autoDispose);
}

/// future
class _FutureValue<T> extends _ContainerValue<T> {
  @override
  final Future<T> value;

  const _FutureValue(
    this.value,
    Function(T)? dispose,
    bool autoDispose,
  ) : super(dispose, autoDispose);
}

/// future function
class _LazyFutureValue<T> extends _ContainerValue<T> {
  @override
  final Future<T> Function() value;

  const _LazyFutureValue(
    this.value,
    Function(T)? dispose,
    bool autoDispose,
  ) : super(dispose, autoDispose);
}

abstract class _ContainerKey {
  final String key;
  const _ContainerKey(this.key);

  @override
  operator ==(covariant _ContainerKey other) {
    return other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}

class _ValueKey extends _ContainerKey {
  const _ValueKey(super.key);
}

class _LazyValueKey extends _ContainerKey {
  const _LazyValueKey(String key) : super("@$key");
}

class _InjectionResult {
  final bool alreadyExist;
  final _ValueKey valueKey;
  final _LazyValueKey lazyValueKey;

  const _InjectionResult(
    this.alreadyExist,
    this.valueKey,
    this.lazyValueKey,
  );
}

class Container {
  final Map<_ContainerKey, _ContainerValue> _store = {};

  _InjectionResult _alreadyInject(String key) {
    /// @
    assert(!key.startsWith("@"));
    final valueKey = _ValueKey(key);
    final lazyValueKey = _LazyValueKey(key);
    return _InjectionResult(
      _store[lazyValueKey] != null || _store[valueKey] != null,
      valueKey,
      lazyValueKey,
    );
  }

  bool set<T>(
    T value, {
    String? instanceName,
    Function(T)? dispose,
    bool autoDispose = false,
  }) {
    final result = _alreadyInject(instanceName ?? T.toString());
    if (result.alreadyExist) return false;
    _store[result.valueKey] = _Value<T>(value, dispose, autoDispose);
    return true;
  }

  bool setSingletone<T>(
    T value, {
    Function(T)? dispose,
    bool autoDispose = false,
  }) {
    final result = _alreadyInject(T.toString());
    if (result.alreadyExist) return false;
    _store[result.valueKey] = _Value<T>(value, dispose, autoDispose);
    return true;
  }

  bool setLazy<T>(
    T Function() value, {
    String? instanceName,
    Function(T)? dispose,
    bool autoDispose = false,
  }) {
    if (T.toString() == "dynamic") {
      throw "Please provide a instance name or Data Type";
    }
    final result = _alreadyInject(instanceName ?? T.toString());
    if (result.alreadyExist) return false;
    _store[result.lazyValueKey] = _LazyValue<T>(value, dispose, autoDispose);
    return true;
  }

  bool setFuture<T>(
    Future<T> value, {
    String? instanceName,
    Function(T)? dispose,
    bool autoDispose = false,
  }) {
    if (T.toString() == "dynamic") {
      throw "Please provide a instance name or Data Type";
    }
    final result = _alreadyInject(instanceName ?? T.toString());
    if (result.alreadyExist) return false;
    _store[result.lazyValueKey] = _FutureValue<T>(value, dispose, autoDispose);
    return true;
  }

  bool setLazyFuture<T>(
    Future<T> Function() value, {
    String? instanceName,
    Function(T)? dispose,
    bool autoDispose = false,
  }) {
    if (T.toString() == "dynamic") {
      throw "Please provide a instance name or Data Type";
    }
    final result = _alreadyInject(instanceName ?? T.toString());
    if (result.alreadyExist) return false;
    _store[result.lazyValueKey] =
        _LazyFutureValue<T>(value, dispose, autoDispose);
    return true;
  }

  Future<void> _dispose<T>(
    _ContainerKey key,
    _ContainerValue<T> container,
  ) async {
    if (container.autoDispose) {
      container.dispose?.call(container.value);
      _store.remove(key);
    }
  }

  T _checkValue<T>(_ContainerKey key, _ContainerValue<T> container) {
    if (container is _LazyValue) {
      final result = container.value();
      final newContainer =
          _Value<T>(result, container.dispose, container.autoDispose);
      _store[key] = newContainer;
      _dispose(key, newContainer);
      return result;
    }
    final result = container.value;
    _dispose(key, container);
    return result;
  }

  T _getContainer<T>(_ValueKey valueKey, _LazyValueKey lazyValueKey) {
    final value = _store[valueKey] as _ContainerValue<T>?;
    final lazyValue = _store[lazyValueKey] as _ContainerValue<T>?;
    if (value == null && lazyValue == null) throw "Not found";
    if (value != null) return _checkValue<T>(valueKey, value);
    return _checkValue<T>(lazyValueKey, lazyValue!);
  }

  T get<T>([String? instanceName]) {
    if (instanceName == null && T.toString() == "dynamic") {
      throw "Please provide a instance name or Data Type";
    }
    final result = _alreadyInject(instanceName ?? T.toString());
    if (!result.alreadyExist) throw "Not found";

    return _getContainer<T>(result.valueKey, result.lazyValueKey);
  }

  Future<T> _checkFutureValue<T>(
    _ContainerKey key,
    _ContainerValue container,
  ) async {
    if (container is _FutureValue) {
      final result = await container.value;
      final newContainer =
          _Value(result, container.dispose, container.autoDispose);
      _store[key] = newContainer;
      _dispose(key, newContainer);
      return result;
    }
    final result = container.value;
    _dispose(key, container);
    return result;
  }

  Future<T> _getFutureContainer<T>(
    _ValueKey valueKey,
    _LazyValueKey lazyValueKey,
  ) async {
    final value = _store[valueKey] as _ContainerValue<T>?;
    final lazyValue = _store[lazyValueKey] as _ContainerValue<T>?;
    if (value == null && lazyValue == null) throw "Not found";
    if (value != null) return _checkValue<T>(valueKey, value);
    return _checkFutureValue<T>(lazyValueKey, lazyValue!);
  }

  Future<T> getFuture<T>([String? instanceName]) async {
    if (instanceName == null && T.toString() == "dynamic") {
      throw "Please provide a instance name or Data Type";
    }
    final result = _alreadyInject(instanceName ?? T.toString());
    if (!result.alreadyExist) throw "Not found";

    return _getFutureContainer<T>(result.valueKey, result.lazyValueKey);
  }

  Future<T> _checkLazyFutureValue<T>(
    _ContainerKey key,
    _ContainerValue<T> container,
  ) async {
    if (container is _LazyFutureValue) {
      final T result = await container.value();
      final newContainer =
          _Value<T>(result, container.dispose, container.autoDispose);
      _store[key] = newContainer;
      _dispose<T>(key, newContainer);
      return result;
    }
    final result = container.value;
    _dispose(key, container);
    return result;
  }

  Future<T> _getLazyFutureContainer<T>(
    _ValueKey valueKey,
    _LazyValueKey lazyValueKey,
  ) async {
    final value = _store[valueKey] as _ContainerValue<T>?;
    final lazyValue = _store[lazyValueKey] as _ContainerValue<T>?;
    if (value == null && lazyValue == null) throw "Not found";
    if (value != null) {
      return _checkValue<T>(valueKey, value);
    }
    return _checkLazyFutureValue<T>(lazyValueKey, lazyValue!);
  }

  Future<T> getLazyFuture<T>([String? instanceName]) async {
    if (instanceName == null && T.toString() == "dynamic") {
      throw "Please provide a instance name or Data Type";
    }
    final result = _alreadyInject(instanceName ?? T.toString());
    if (!result.alreadyExist) throw "Not found";

    return _getLazyFutureContainer<T>(result.valueKey, result.lazyValueKey);
  }

  void remove<T>([String? instanceName]) {
    if (instanceName == null && T.toString() == "dynamic") {
      throw "Please provide a instance name or Data Type";
    }
    final result = _alreadyInject(instanceName ?? T.toString());
    if (!result.alreadyExist) throw "Not found";

    if (_store[result.valueKey] != null) {
      _store.remove(result.valueKey);
      return;
    }
    _store.remove(result.lazyValueKey);
  }

  bool exists<T>([String? instanceName]) {
    if (instanceName == null && T.toString() == "dynamic") {
      throw "Please provide a instance name or Data Type";
    }
    final result = _alreadyInject(instanceName ?? T.toString());
    return result.alreadyExist;
  }
}
