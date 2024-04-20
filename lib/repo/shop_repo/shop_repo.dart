import 'package:inventory_management_with_sql/core/db/impl/sqlite_repo.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_interface.dart';
import 'package:inventory_management_with_sql/core/db/utils/const.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_entity.dart';
import 'package:sqflite/sqflite.dart';

class ShopRepo extends SqliteRepo<Shop, ShopParam> {
  ShopRepo(DataStore<Database> store) : super(store, Shop.fromJson, shopTb);
}
