import 'dart:async';

import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

class DashboardEngineRepo {
  final String shopName;
  final SqliteDatabase database;
  final StreamController<Result> _isReady;

  DashboardEngineRepo({
    required this.shopName,
    required this.database,
  }) : _isReady = StreamController<Result>.broadcast();

  Stream<Result> get isReady => _isReady.stream;

  Future<void> init() async {
    final result = await database.connect();
    _isReady.sink.add(result);
  }

  Future<void> dispose() async {
    await Future.wait([_isReady.close(), database.close()]);
  }
}
