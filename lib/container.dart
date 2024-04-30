import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management_with_sql/core/bloc/bloc_observer.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/utils/const.dart';
import 'package:inventory_management_with_sql/core/injection/injection.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_repo.dart';

final Container container = Container();

Future<void> setup() async {
  Bloc.observer = CustomBlocObserver();

  container.setSingletone(SqliteDatabase.newInstance(
    shopDbName,
    shopTableColumns,
    1,
  ));

  await container.get<SqliteDatabase>().connect();

  container.setLazy(() => ImagePicker());

  container.setLazy(() => SqliteShopRepo(
        container.get<SqliteDatabase>(),
      ));
}
