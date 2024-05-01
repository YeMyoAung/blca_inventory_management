import 'package:inventory_management_with_sql/core/bloc/bloc_state.dart';

abstract class CreateNewCategoryState extends BasicState {}

class CreateNewCategoryInitalState extends CreateNewCategoryState {}

class CreateNewCategoryCreatingState extends CreateNewCategoryState {}

class CreateNewCategoryErrorState extends CreateNewCategoryState {
  final String message;

  CreateNewCategoryErrorState(this.message);
}

class CreateNewCategoryCreatedState extends CreateNewCategoryState {}
