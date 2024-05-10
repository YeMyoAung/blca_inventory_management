import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_event.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_form.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_state.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_create_new_product_use_case.dart';

class CreateNewProductBloc extends SqliteCreateBloc<Product,
    VariantProductParams, SqliteCreateNewProductUseCase, CreateNewProductForm> {
  final ImagePicker imagePicker;

  CreateNewProductBloc(
    super.form,
    this.imagePicker,
    super.useCase,
  ) {
    on<CreateNewProductPickCoverPhotoEvent>(
        _createNewProductPickerCoverPhotoEventListener);
    on<CreateNewProductAvailabeToSellWhenOutOfStockEvent>(
        _createNewProductAvailableToSellWhenOutOfStockEventListener);
    on<CreateNewProducCategorySelectEvent>(
      (CreateNewProducCategorySelectEvent event, emit) {
        form.category.input = event.category;
        emit(CreateNewProductCategorySelectedState());
      },
    );
  }

  FutureOr<void> _createNewProductAvailableToSellWhenOutOfStockEventListener(
      CreateNewProductAvailabeToSellWhenOutOfStockEvent event, emit) {
    form.availableToSellWhenOutOfStock.input = event.canSell;
    emit(CreateNewProductAvailableToSellWhenOutOfStockSelectedState());
  }

  Future<void> _createNewProductPickerCoverPhotoEventListener(_, emit) async {
    form.coverPhoto.input =
        (await imagePicker.pickImage(source: ImageSource.gallery))?.path;
    if (form.coverPhoto.input != null) {
      emit(CreateNewProductCoverPhotoSelectedState());
    }
  }
}
