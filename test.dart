import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

class _ContainerValue<T> {
  final T value;

  const _ContainerValue(this.value);
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

  bool set<T>(T value, {String? instanceName}) {
    final result = _alreadyInject(instanceName ?? T.toString());
    if (result.alreadyExist) return false;
    _store[result.valueKey] = _ContainerValue(value);
    return true;
  }

  bool setSingletone<T>(T value) {
    final result = _alreadyInject(T.toString());
    if (result.alreadyExist) return false;
    _store[result.valueKey] = _ContainerValue(value);
    return true;
  }

  bool setLazy<T>(T Function() value, {String? instanceName}) {
    if (T.toString() == "dynamic") {
      throw "Please provide a instance name or Data Type";
    }
    final result = _alreadyInject(instanceName ?? T.toString());
    if (result.alreadyExist) return false;
    _store[result.lazyValueKey] = _ContainerValue(value);
    return true;
  }

  bool setFuture<T>(Future<T> value, {String? instanceName}) {
    if (T.toString() == "dynamic") {
      throw "Please provide a instance name or Data Type";
    }
    final result = _alreadyInject(instanceName ?? T.toString());
    if (result.alreadyExist) return false;
    _store[result.lazyValueKey] = _ContainerValue(value);
    return true;
  }

  T _checkValue<T>(_ContainerKey key, _ContainerValue container) {
    if (container.value is Function && key is _LazyValueKey) {
      final result = container.value();
      _store[key] = _ContainerValue(result);
      return result;
    }
    return container.value;
  }

  T _getContainer<T>(_ValueKey valueKey, _LazyValueKey lazyValueKey) {
    final value = _store[valueKey];
    final lazyValue = _store[lazyValueKey];
    if (value == null && lazyValue == null) throw "Not found";
    if (value != null) return _checkValue(valueKey, value);
    return _checkValue(lazyValueKey, lazyValue!);
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
      _ContainerKey key, _ContainerValue container) async {
    if (container.value is Future && key is _LazyValueKey) {
      final result = await container.value;
      _store[key] = _ContainerValue(result);
      return result;
    }
    return container.value;
  }

  Future<T> _getFutureContainer<T>(
      _ValueKey valueKey, _LazyValueKey lazyValueKey) {
    final value = _store[valueKey];
    final lazyValue = _store[lazyValueKey];
    if (value == null && lazyValue == null) throw "Not found";
    if (value != null) return _checkValue(valueKey, value);
    return _checkFutureValue(lazyValueKey, lazyValue!);
  }

  Future<T> getFuture<T>([String? instanceName]) async {
    if (instanceName == null && T.toString() == "dynamic") {
      throw "Please provide a instance name or Data Type";
    }
    final result = _alreadyInject(instanceName ?? T.toString());
    if (!result.alreadyExist) throw "Not found";

    return _getFutureContainer<T>(result.valueKey, result.lazyValueKey);
  }
}

void main() async {
  final c = Container();

  // c.setSingletone("Hello World");
  // c.set("Hello World H1");
  // c.set("Hi World", instanceName: "hi");

  c.setFuture<A>(() async {
    print("Future");
    return A(id: 1);
  }());

  print(await c.getFuture<A>());
  print(c.get<A>());
  print(c.get<A>());

  // String name = """Create table if not exists users (
  //       id integer primary key autoincrement,
  //       created_at text not null,
  //       updated_at text,
  //       name varchar(255) not null,""";
  // print(name[name.length - 2]);
  // print(name[name.length - 1]);
  // // print(name[name.length]);
  // name.replaceFirst(",", "", name.length - 2);
  // print(A(id: 1) == A(id: 1));
}

class A extends DatabaseModel {
  A({required super.id});

  @override
  Map<String, dynamic> toJson() {
    return {"a": "This is A"};
  }
}

class B extends DatabaseModel {
  B({required super.id});

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
