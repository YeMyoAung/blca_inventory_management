import 'package:inventory_management_with_sql/core/bloc/bloc_state.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

// const array = fix size
//       list  = dynamic size

abstract class SqliteState<Model extends DatabaseModel> extends BasicState {
  final List<Model> list;

  SqliteState(this.list);
}

class SqliteInitialState<Model extends DatabaseModel>
    extends SqliteState<Model> {
  SqliteInitialState(List<Model> list) : super(list);
}

class SqliteLoadingState<Model extends DatabaseModel>
    extends SqliteState<Model> {
  SqliteLoadingState(super.list);
}

class SqliteSoftLoadingState<Model extends DatabaseModel>
    extends SqliteState<Model> {
  SqliteSoftLoadingState(super.list);
}

class SqliteReceiveState<Model extends DatabaseModel>
    extends SqliteState<Model> {
  SqliteReceiveState(super.list);
}

class SqliteErrorState<Model extends DatabaseModel> extends SqliteState<Model> {
  final String message;

  SqliteErrorState(super.list, this.message);
}
