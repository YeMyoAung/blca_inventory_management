import 'package:inventory_management_with_sql/core/bloc/bloc_state.dart';

abstract class SqliteCreateBaseState extends BlocBaseState {
  SqliteCreateBaseState();
}

class SqliteCreateInitialState extends SqliteCreateBaseState {}

class SqliteCreatingState extends SqliteCreateBaseState {}

class SqliteCreateErrorState extends SqliteCreateBaseState {
  final String message;

  SqliteCreateErrorState(this.message);
  @override
  String toString() {
    return "${runtimeType.toString()}\n$message";
  }
}

class SqliteCreatedState extends SqliteCreateBaseState {}
