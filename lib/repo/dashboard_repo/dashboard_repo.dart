import 'dart:async';

import 'package:inventory_management_with_sql/container.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/attribute_repo/attribute_repo.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_repo.dart';
import 'package:inventory_management_with_sql/repo/inventory_repo/inventory_repo.dart';
import 'package:inventory_management_with_sql/repo/option_repo/option_repo.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_repo.dart';
import 'package:inventory_management_with_sql/repo/variant_properties_repo/variant_property_repo.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';

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

    ///variant repo
    container.setLazy<SqliteVariantRepo>(() {
      return SqliteVariantRepo(database);
    });

    ///option repo
    container.setLazy<SqliteOptionRepo>(() {
      return SqliteOptionRepo(database);
    });

    ///attribute repo
    container.setLazy<SqliteAttributeRepo>(() {
      return SqliteAttributeRepo(database);
    });

    ///varaint properites repo
    container.setLazy<SqliteVariantPropertyRepo>(() {
      return SqliteVariantPropertyRepo(database);
    });

    ///inventory repo
    container.setLazy<SqliteInventoryRepo>(() {
      return SqliteInventoryRepo(database);
    });

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
