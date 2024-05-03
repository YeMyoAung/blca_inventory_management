import 'package:inventory_management_with_sql/core/bloc/bloc_state.dart';

abstract class SqliteCreateState extends BasicState {
  SqliteCreateState();
}

class SqliteCreateInitialState extends SqliteCreateState {}

class SqliteCreatingState extends SqliteCreateState {}

class SqliteCreateErrorState extends SqliteCreateState {
  final String message;

  SqliteCreateErrorState(this.message);
  @override
  String toString() {
    // TODO: implement toString
    return "${runtimeType.toString()}\n$message";
  }
}

class SqliteCreatedState extends SqliteCreateState {}
