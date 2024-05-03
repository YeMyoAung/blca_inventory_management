import 'dart:async';

import 'package:inventory_management_with_sql/container.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_repo.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_repo.dart';

class DashboardEngineRepo {
  final String shopName;
  final SqliteDatabase database;
  final StreamController<Result> _isReady;

  DashboardEngineRepo({
    required this.shopName,
    required this.database,
  }) : _isReady = StreamController<Result>.broadcast();

  Stream<Result> get isReady => _isReady.stream;

  void _validate() {
    assert(container.exists<SqliteCategoryRepo>() &&
        container.exists<SqliteProductRepo>());
  }

  Future<void> init() async {
    final result = await database.connect();

    ///category repo
    container.setLazy<SqliteCategoryRepo>(() {
      return SqliteCategoryRepo(database);
    });

    ///product repo
    container.setLazy<SqliteProductRepo>(() {
      return SqliteProductRepo(database);
    });

    ///inventory repo
    ///TODO

    _validate();

    _isReady.sink.add(result);
  }

  Future<void> dispose() async {
    _validate();
    await Future.wait([
      _isReady.close(),
      database.close(),
    ]);
    container.remove<SqliteCategoryRepo>();
    container.remove<SqliteProductRepo>();
  }
}
