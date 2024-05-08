import 'package:inventory_management_with_sql/core/bloc/bloc_state.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

// const array = fix size
//       list  = dynamic size

abstract class SqliteReadState<Model extends DatabaseModel> extends BasicState {
  final List<Model> list;

  SqliteReadState(this.list);
}

class SqliteInitialState<Model extends DatabaseModel>
    extends SqliteReadState<Model> {
  SqliteInitialState(List<Model> list) : super(list);
}

class SqliteLoadingState<Model extends DatabaseModel>
    extends SqliteReadState<Model> {
  SqliteLoadingState(super.list);
}

class SqliteSoftLoadingState<Model extends DatabaseModel>
    extends SqliteReadState<Model> {
  SqliteSoftLoadingState(super.list);
}

class SqliteReceiveState<Model extends DatabaseModel>
    extends SqliteReadState<Model> {
  SqliteReceiveState(super.list);
}

class SqliteErrorState<Model extends DatabaseModel>
    extends SqliteReadState<Model> {
  final String message;

  SqliteErrorState(super.list, this.message);
}
