import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management_with_sql/cateogry/controller/category_list_bloc.dart';
import 'package:inventory_management_with_sql/container.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/utils/const.dart';
import 'package:inventory_management_with_sql/create_new_category/controller/create_new_category_bloc.dart';
import 'package:inventory_management_with_sql/create_new_category/controller/create_new_category_state.dart';
import 'package:inventory_management_with_sql/create_new_category/screen/create_new_category_screen.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_state.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_with_form_bloc.dart';
import 'package:inventory_management_with_sql/create_new_shop/screen/create_new_shop_screen.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_navigation_bloc.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_navigation_state.dart';
import 'package:inventory_management_with_sql/dashboard/screen/dashboard_screen.dart';
import 'package:inventory_management_with_sql/dashboard_loader/controller/dashboard_engine_bloc.dart';
import 'package:inventory_management_with_sql/dashboard_loader/controller/dashboard_engine_state.dart';
import 'package:inventory_management_with_sql/dashboard_loader/screen/dashboard_loader_screen.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_repo.dart';
import 'package:inventory_management_with_sql/repo/dashboard_repo/dashboard_repo.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_entity.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_repo.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/shop_list/controller/shop_list_bloc.dart';
import 'package:inventory_management_with_sql/shop_list/screen/shop_list_screen.dart';

Route _shopScreen(RouteSettings settings) {
  return _route(
    BlocProvider(
      create: (_) => ShopListBloc(
        SqliteInitialState(<Shop>[]),
        container.get<SqliteShopRepo>(),
      ),
      child: const ShopListScreen(),
    ),
    settings,
  );
}

final Map<String, Route Function(RouteSettings setting)> dashboardLoaderRoute =
    {
  dashboardLoading: (settings) {
    final arg = settings.arguments;
    if (arg is! String) {
      ///TODO
      return _route(ErrorWidget("Bad request"), settings);
    }

    if (container.exists<DashboardEngineBloc>()) {
      return _route(
        BlocProvider.value(
          value: container.get<DashboardEngineBloc>(),
          child: const DashboardLoadingScreen(),
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
                  arg,
                  inventoryMangementTableColumns,
                ),
              ),
            ),
          );
          return container.get<DashboardEngineBloc>();
        },
        child: const DashboardLoadingScreen(),
      ),
      settings,
    );
  }
};

final Map<String, Route Function(RouteSettings)> dashboardRoute = {
  dashboard: (settings) {
    if (!container.exists<DashboardEngineBloc>()) {
      return _shopScreen(settings);
    }
    return _route(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: container.get<DashboardEngineBloc>(),
          ),
          BlocProvider(
            create: (_) => CategoryListBloc(
              SqliteInitialState(<Category>[]),
              container.get<SqliteCategoryRepo>(),
            ),
          ),
          BlocProvider(
            create: (_) => DashboardNavigationBloc(
              const DashboardNavigationState(0),
            ),
          )
        ],
        child: const DashboardScreen(),
      ),
      settings,
    );
  }
};

final Map<String, Route Function(RouteSettings setting)> routes = {
  shopList: (settings) => _shopScreen(settings),
  createNewShop: (settings) => _route(
        BlocProvider(
          create: (_) => CreateNewShopWithFormBloc(
            CreateNewShopInitialState(),
            ShopCreateForm.form(),
            container.get<SqliteShopRepo>(),
            container.get<ImagePicker>(),
          ),
          child: const CreateNewShopScreen(),
        ),
        settings,
      ),
  ...dashboardLoaderRoute,
  ...dashboardRoute,
  createNewCategory: (settings) => _route(
      BlocProvider(
          create: (_) => CreateNewCategoryBloc(
                CreateNewCategoryInitalState(),
                container.get<SqliteCategoryRepo>(),
              ),
          child: const CreateNewCategoryScreen()),
      settings),
};

Route router(RouteSettings settings) {
  return routes[settings.name]?.call(settings) ?? _shopScreen(settings);
}

Route _route(Widget child, RouteSettings settings) {
  return CupertinoPageRoute(
    builder: (_) {
      return child;
    },
    settings: settings,
  );
}
