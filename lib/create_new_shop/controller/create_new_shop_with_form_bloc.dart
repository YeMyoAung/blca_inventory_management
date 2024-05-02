import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/form/field.dart';
import 'package:inventory_management_with_sql/core/form/form.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_event.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_state.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_entity.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_repo.dart';

class ShopCreateForm implements FormGroup<ShopParam> {
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  final Field<TextEditingController> name;
  final Field<String> coverPhoto;

  ShopCreateForm._({
    required this.name,
    required this.coverPhoto,
  });

  factory ShopCreateForm.form() {
    return ShopCreateForm._(
      name: Field(
        input: TextEditingController(),
        isRequired: false,
        dispose: (p0) => p0?.dispose(),
      ),
      coverPhoto: Field(
        isValid: (p0) =>
            p0?.isNotEmpty == true ? null : "Cover photo is missing",
      ),
    );
  }

  @override
  List<Field> get form => [name, coverPhoto];

  @override
  Result<ShopParam> toParam() {
    final errorMessage = formIsValid(form);
    return errorMessage == null
        ? Result(
            result: ShopParam.toCreate(
              name: name.input!.text,
              coverPhoto: coverPhoto.input!,
            ),
          )
        : Result(
            exception: Error(errorMessage),
          );
  }

  @override
  dispose() {
    formKey = null;
    formDispose(form);
  }
}

class CreateNewShopWithFormBloc
    extends Bloc<CreateNewShopEvent, CreateNewShopState> {
  final ShopCreateForm form;
  final SqliteShopRepo shopRepo;
  final ImagePicker imagePicker;
  CreateNewShopWithFormBloc(
    super.initialState,
    this.form,
    this.shopRepo,
    this.imagePicker,
  ) {
    on<CreateNewShopPickCoverPhotoEvent>(
        _createNewShopPickCoverPhotoEventListener);

    on<CreateNewShopCreateShopEvent>(_createNewShopCreateShopEventListener);
  }

  FutureOr<void> _createNewShopCreateShopEventListener(_, emit) async {
    if (state is CreateNewShopCreatingState) return;
    if (form.formKey?.currentState?.validate() != true) return;
    final param = form.toParam();
    if (param.hasError) {
      return emit(
        CreateNewShopErrorState(
          message: param.toString(),
        ),
      );
    }
    emit(CreateNewShopCreatingState());
    final result = await shopRepo.create(param.result!);
    if (result.hasError) {
      return emit(
        CreateNewShopErrorState(
          message: result.toString(),
        ),
      );
    }

    emit(CreateNewShopCreatedState());
  }

  FutureOr<void> _createNewShopPickCoverPhotoEventListener(_, emit) async {
    final picked = await imagePicker.pickImage(source: ImageSource.gallery);
    if (picked == null) {
      return;
    }
    form.coverPhoto.input = picked.path;
    emit(CreateNewShopCoverPhotoSelectedState());
  }

  @override
  Future<void> close() {
    form.dispose();
    return super.close();
  }
}
