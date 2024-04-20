import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/utils/const.dart';
import 'package:inventory_management_with_sql/create_new_shop/screen/create_new_shop_screen.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_repo.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/shop/controller/shop_list_bloc.dart';
import 'package:inventory_management_with_sql/shop/controller/shop_list_state.dart';
import 'package:inventory_management_with_sql/shop/screen/shop_screen.dart';

Route _shopScreen(RouteSettings settings) {
  return _route(
    BlocProvider(
      create: (_) => ShopListBloc(
        ShopListInitialState(),
        ShopRepo(
          SqliteDatabase.getInstance(shopDbName),
        ),
      ),
      child: const ShopScreen(),
    ),
    settings,
  );
}

Route router(RouteSettings settings) {
  switch (settings.name) {
    case shopList:
      return _shopScreen(settings);
    case createNewShop:
      return _route(const CreateNewShopScreen(), settings);
    default:
      return _shopScreen(settings);
  }
}

Route _route(Widget child, RouteSettings settings) {
  return CupertinoPageRoute(
    builder: (_) {
      return child;
    },
    settings: settings,
  );
}
