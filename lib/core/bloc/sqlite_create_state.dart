import 'package:inventory_management_with_sql/core/bloc/bloc_state.dart';

abstract class SqliteExecuteBaseState extends BlocBaseState {
  SqliteExecuteBaseState();
}

class SqliteExecuteInitialState extends SqliteExecuteBaseState {}

class SqliteExecutingState extends SqliteExecuteBaseState {}

class SqliteExecuteErrorState extends SqliteExecuteBaseState {
  final String message;

  SqliteExecuteErrorState(this.message);
  @override
  String toString() {
    return "${runtimeType.toString()}\n$message";
  }
}

class SqliteExecuteState extends SqliteExecuteBaseState {}
