import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_event.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_form.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_state.dart';
import 'package:inventory_management_with_sql/create_new_shop/use_case/sqlite_create_new_shop_use_case.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_entity.dart';

class CreateNewShopBloc extends SqliteCreateBloc<Shop, ShopParam,
    SqliteShopCreateUseCase, ShopCreateForm, NullObject> {
  final ImagePicker imagePicker;
  CreateNewShopBloc(
    super.form,
    super.useCase,
    this.imagePicker,
  ) {
    on<CreateNewShopPickCoverPhotoEvent>(
        _createNewShopPickCoverPhotoEventListener);
  }

  FutureOr<void> _createNewShopPickCoverPhotoEventListener(_, emit) async {
    final picked = await imagePicker.pickImage(source: ImageSource.gallery);
    if (picked == null) {
      return;
    }
    form.coverPhoto.input = picked.path;
    emit(CreateNewShopCoverPhotoSelectedState());
  }
}
