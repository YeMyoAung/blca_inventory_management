import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/create_new_category/controller/create_new_category_event.dart';
import 'package:inventory_management_with_sql/create_new_category/controller/create_new_category_state.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_repo.dart';

class CreateNewCategoryBloc
    extends Bloc<CreateNewCategoryEvent, CreateNewCategoryState> {
  final SqliteCategoryRepo repo;
  final TextEditingController nameController;
  CreateNewCategoryBloc(super.initialState, this.repo)
      : nameController = TextEditingController() {
    on<CreateNewCategoryEvent>(_createNewCategoryEventListener);
  }

  FutureOr<void> _createNewCategoryEventListener(_, emit) async {
    if (state is CreateNewCategoryCreatingState) return;
    assert(formKey?.currentState?.validate() == true);
    emit(CreateNewCategoryCreatingState());
    final result =
        await repo.create(CategoryParams.create(name: nameController.text));
    if (result.hasError) {
      return emit(CreateNewCategoryErrorState(result.toString()));
    }
    emit(CreateNewCategoryCreatedState());
  }

  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  @override
  Future<void> close() {
    nameController.dispose();
    formKey = null;
    return super.close();
  }
}
