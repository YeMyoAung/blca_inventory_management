import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_event.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_form.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_state.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_create_new_product_use_case.dart';

class CreateNewProductBloc extends SqliteCreateBloc<Product,
    VariantProductParams, SqliteCreateNewProductUseCase, CreateNewProductForm> {
  final ImagePicker imagePicker;

  //left index => ui index
  //right index => form index
  Map<int, int> variantUiAndFormIndexMapper = {};

  CreateNewVariantForm? singleProductForm;

  void addVariant(int index) {
    /// single product (variant)= [singleProductFrom]
    /// variant[0] is singleProduct => singleProduct store
    /// varint (1) length=>1,index => 0
    /// index 0 exist => 1
    print("Before: $variantUiAndFormIndexMapper");
    final leftMostV = form.varaints[0];
    if (!leftMostV.isVariant) {
      ///origin
      singleProductForm = leftMostV;
      form.varaints.clear();
    }
    // final afterAddingIndex = form.varaints.length; //(1)
    form.varaints.add(CreateNewVariantForm.form(true)); //length 2,(1,2) ,(0,1)
    variantUiAndFormIndexMapper[index] = form.varaints.length - 1;
    print("After: $variantUiAndFormIndexMapper");
  }

  void removeVariant(int index) {
    print("Before: $variantUiAndFormIndexMapper ${form.varaints}");
    final formIndex = variantUiAndFormIndexMapper.remove(index);
    if (formIndex == null) return;
    final result = form.varaints.toList()..removeAt(formIndex);

    ///[1,2,3] => [1,3]
    form.varaints.clear();
    form.varaints.addAll(result);
    if (form.varaints.isEmpty && singleProductForm != null) {
      form.varaints.add(singleProductForm!);
      form.index = 0;
    }

    variantUiAndFormIndexMapper = variantUiAndFormIndexMapper.map((key, value) {
      return MapEntry(key, formIndex < value ? value - 1 : value);
    });

    print("After: $variantUiAndFormIndexMapper ${form.varaints}");
  }

  void changeToSingleProduct() {
    print(singleProductForm);
    print("Before: $variantUiAndFormIndexMapper");

    if (singleProductForm != null) return;
    form.varaints.clear();
    form.varaints.add(singleProductForm!);
    form.index = 0;

    print("After: $variantUiAndFormIndexMapper");
  }

  CreateNewProductBloc(
    super.form,
    this.imagePicker,
    super.useCase,
  ) {
    on<CreateNewProductPickCoverPhotoEvent>(
      _createNewProductPickCoverPhotoEventListener,
    );
    on<CreateNewProductAvailabeToSellWhenOutOfStockEvent>(
      _createNewProductAvailableToSellWhenOutOfStockEventListener,
    );
    on<CreateNewProducCategorySelectEvent>(
      _createNewProductCategorySelectEvent,
    );
    on<CreateNewProductNewStockEvent>(_createNewProductNewStockEvent);

    on<CreateNewProductSetPriceEvent>((CreateNewProductSetPriceEvent event,
        Emitter<SqliteCreateBaseState> emit) {
      emit(CreateNewProductSetPriceState(index: event.index));
    });
  }

  FutureOr<void> _createNewProductNewStockEvent(
    CreateNewProductNewStockEvent _,
    Emitter<SqliteCreateBaseState> emit,
  ) {
    emit(CreateNewProductNewStockState());
  }

  FutureOr<void> _createNewProductCategorySelectEvent(
    CreateNewProducCategorySelectEvent event,
    Emitter<SqliteCreateBaseState> emit,
  ) {
    form.category.input = event.category;
    emit(CreateNewProductCategorySelectedState());
  }

  FutureOr<void> _createNewProductAvailableToSellWhenOutOfStockEventListener(
    CreateNewProductAvailabeToSellWhenOutOfStockEvent event,
    Emitter<SqliteCreateBaseState> emit,
  ) {
    form.availableToSellWhenOutOfStock.input = event.canSell;
    emit(CreateNewProductAvailableToSellWhenOutOfStockSelectedState());
  }

  Future<void> _createNewProductPickCoverPhotoEventListener(
    CreateNewProductPickCoverPhotoEvent _,
    Emitter<SqliteCreateBaseState> emit,
  ) async {
    form.coverPhoto.input =
        (await imagePicker.pickImage(source: ImageSource.gallery))?.path;
    if (form.coverPhoto.input != null) {
      emit(CreateNewProductCoverPhotoSelectedState());
    }
  }

  @override
  Result<VariantProductParams> toParam() {
    print("Before Generate Param");
    final result = super.toParam();
    print("After Generate Param $result");
    return result;
  }

  @override
  bool isValid() {
    print("Before From Validate");
    final result = super.isValid();
    print("After From Validate");
    return result;
  }

  @override
  FutureOr<Result<Product>> onCreate(VariantProductParams param) {
    print("Before Create");

    // final result = super.onCreate(param);

    print("After Create");

    return Result(exception: Error("Product Create Step"));
  }
}
