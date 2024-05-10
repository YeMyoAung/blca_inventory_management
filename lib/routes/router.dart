import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management_with_sql/cateogry/controller/category_list_bloc.dart';
import 'package:inventory_management_with_sql/cateogry/screen/add_category_screen.dart';
import 'package:inventory_management_with_sql/container.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';
import 'package:inventory_management_with_sql/create_new_category/controller/create_new_category_bloc.dart';
import 'package:inventory_management_with_sql/create_new_category/controller/create_new_category_form.dart';
import 'package:inventory_management_with_sql/create_new_category/screen/create_new_category_screen.dart';
import 'package:inventory_management_with_sql/create_new_category/use_case/sqlite_create_new_category_use_case.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_form.dart';
import 'package:inventory_management_with_sql/create_new_product/screen/create_new_product_screen.dart';
import 'package:inventory_management_with_sql/create_new_product/screen/set_product_inventory_screen.dart';
import 'package:inventory_management_with_sql/create_new_product/screen/set_product_price_screen.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_form.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_with_form_bloc.dart';
import 'package:inventory_management_with_sql/create_new_shop/screen/create_new_shop_screen.dart';
import 'package:inventory_management_with_sql/create_new_shop/use_case/sqlite_create_new_shop_use_case.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_navigation_bloc.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_navigation_state.dart';
import 'package:inventory_management_with_sql/dashboard/screen/dashboard_screen.dart';
import 'package:inventory_management_with_sql/dashboard_loader/controller/dashboard_engine_bloc.dart';
import 'package:inventory_management_with_sql/dashboard_loader/controller/dashboard_engine_state.dart';
import 'package:inventory_management_with_sql/dashboard_loader/screen/dashboard_loader_screen.dart';
import 'package:inventory_management_with_sql/product/controller/product_list_bloc.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_repo.dart';
import 'package:inventory_management_with_sql/repo/dashboard_repo/dashboard_repo.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_repo.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_repo.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/shop_list/controller/shop_list_bloc.dart';
import 'package:inventory_management_with_sql/shop_list/screen/shop_list_screen.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_create_new_product_use_case.dart';

Route _shopScreen(RouteSettings settings) {
  return _route(
    BlocProvider(
      create: (_) => ShopListBloc(
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
                  // 1,
                  // 2,
                  3,
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
              container.get<SqliteCategoryRepo>(),
            ),
          ),
          BlocProvider(
            create: (_) => ProductListBloc(
              container.get<SqliteProductRepo>(),
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
          create: (_) => CreateNewShopBloc(
            ShopCreateForm.form(),
            SqliteShopCreateUseCase(
              shopRepo: container.get<SqliteShopRepo>(),
            ),
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
            CreateNewCategoryForm.form(),
            SqliteCategoryCreateUseCase(
                categoryRepo: container.get<SqliteCategoryRepo>()),
          ),
          child: const CreateNewCategoryScreen(),
        ),
        settings,
      ),
  createNewProduct: (settings) {
    final value = settings.arguments;
    if (value is! CategoryListBloc) {
      return _route(
        ErrorWidget("Category List Bloc not found"),
        settings,
      );
    }
    return _route(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CreateNewProductBloc(
              CreateNewProductForm.form(),
              container.get<ImagePicker>(),
              SqliteCreateNewProductUseCase(
                productRepo: container.get<SqliteProductRepo>(),
                variantRepo: container.get<SqliteVariantRepo>(),
              ),
            ),
          ),
          BlocProvider.value(value: value),
        ],
        child: const CreateNewProductScreen(),
      ),
      settings,
    );
  },
  addCategoryScreen: (settings) {
    final bloc = settings.arguments;
    if (bloc is! CategoryListBloc) {
      return _route(ErrorWidget("Category List Bloc Not Found"), settings);
    }
    return _route(
      BlocProvider.value(
        value: bloc,
        child: const AddCategoryScreen(),
      ),
      settings,
    );
  },
  setProductPriceScreen: (settings) {
    final bloc = settings.arguments;
    if (bloc is! CreateNewProductBloc) {
      return _route(
        ErrorWidget("Create new product bloc not found"),
        settings,
      );
    }
    return _route(
      BlocProvider.value(value: bloc, child: const SetProductPriceScreen()),
      settings,
    );
  },
  setProductInventoryScreen: (settings) {
    final bloc = settings.arguments;
    if (bloc is! CreateNewProductBloc) {
      return _route(
        ErrorWidget("Create new product bloc not found"),
        settings,
      );
    }

    return _route(
      BlocProvider.value(
        value: bloc,
        child: const SetProductInventoryScreen(),
      ),
      settings,
    );
  }
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
