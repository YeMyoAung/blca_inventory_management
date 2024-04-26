import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management_with_sql/container.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/utils/const.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_bloc.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_state.dart';
import 'package:inventory_management_with_sql/create_new_shop/screen/create_new_shop_screen.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_engine_bloc.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_engine_state.dart';
import 'package:inventory_management_with_sql/dashboard/screen/dashboard_screen.dart';
import 'package:inventory_management_with_sql/repo/dashboard_repo/dashboard_repo.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_repo.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/shop_list/controller/shop_list_bloc.dart';
import 'package:inventory_management_with_sql/shop_list/controller/shop_list_state.dart';
import 'package:inventory_management_with_sql/shop_list/screen/shop_list_screen.dart';

Route _shopScreen(RouteSettings settings) {
  return _route(
    BlocProvider(
      create: (_) => ShopListBloc(
        ShopListInitialState(),
        container.get<ShopRepo>(),
      ),
      child: const ShopListScreen(),
    ),
    settings,
  );
}

Route router(RouteSettings settings) {
  switch (settings.name) {
    case shopList:
      return _shopScreen(settings);
    case createNewShop:
      return _route(
        BlocProvider(
          create: (_) => CreateNewShopBloc(
            CreateNewShopInitialState(),
            container.get<ShopRepo>(),
            container.get<ImagePicker>(),
          ),
          child: const CreateNewShopScreen(),
        ),
        settings,
      );
    case dashboard:

      ///1 check arg
      ///2 check bloc
      ///BlocProvider.value || BlocProvider
      final arg = settings.arguments;
      if (arg is! String) {
        ///TODO
        return _route(ErrorWidget("Bad request"), settings);
      }

      if (container.exists<DashboardEngineBloc>(arg)) {
        return _route(
          BlocProvider.value(
            value: container.get<DashboardEngineBloc>(arg),
            child: const DashboardScreen(),
          ),
          settings,
        );
      }

      return _route(
        BlocProvider(
          create: (_) {
            container.set(
              DashboardEngineBloc(
                const DashboardEngineInitialState(),
                DashboardEngineRepo(
                  shopName: arg,
                  database: SqliteDatabase.newInstance(
                      shopDbName, inventoryMangementTableColumns),
                ),
              ),
              instanceName: arg,
            );
            return container.get<DashboardEngineBloc>(arg);
          },
          child: const DashboardScreen(),
        ),
        settings,
      );
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
