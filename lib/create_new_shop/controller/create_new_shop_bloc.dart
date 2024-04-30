import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_event.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_state.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_entity.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_repo.dart';

class CreateNewShopBloc extends Bloc<CreateNewShopEvent, CreateNewShopState> {
  final TextEditingController controller;
  final ImagePicker imagePicker;
  final SqliteShopRepo shopRepo;
  CreateNewShopBloc(
    super.initialState,
    this.shopRepo,
    this.imagePicker,
  ) : controller = TextEditingController() {
    on<CreateNewShopPickCoverPhotoEvent>(
        _createNewShopPickCoverPhotoEventListener);

    on<CreateNewShopCreateShopEvent>(_createNewShopCreateShopEventListener);
  }

  FutureOr<void> _createNewShopCreateShopEventListener(event, emit) async {
    assert(formKey?.currentState?.validate() == true);

    if (state.coverPhotoPath == null) {
      return emit(CreateNewShopErrorState(
        message: "Cover photo is missing",
        coverPhotoPath: null,
      ));
    }

    if (state is CreateNewShopCreatingState) return;

    emit(CreateNewShopCreatingState(coverPhotoPath: state.coverPhotoPath));
    final result = await shopRepo.create(
      ShopParam.toCreate(
        name: controller.text,
        coverPhoto: state.coverPhotoPath!,
      ),
    );
    logger.i("CreateNewShopCreateShopEvent Result: $result");
    if (result.hasError) {
      logger.e(
          "CreateNewShopCreateShopEvent Error: ${result.exception?.stackTrace}");

      emit(CreateNewShopErrorState(
        coverPhotoPath: state.coverPhotoPath,
        message: result.toString(),
      ));
      return;
    }
    emit(CreateNewShopCreatedState());
  }

  FutureOr<void> _createNewShopPickCoverPhotoEventListener(_, emit) async {
    final file = await imagePicker.pickImage(source: ImageSource.gallery);

    emit(CreateNewShopCoverPhotoSelectedState(coverPhotoPath: file?.path));
  }

  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  @override
  Future<void> close() {
    controller.dispose();
    formKey = null;
    return super.close();
  }
}
