import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_event.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_state.dart';
import 'package:inventory_management_with_sql/theme/theme.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewProductInfo extends StatelessWidget {
  const CreateNewProductInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    final theme = context.theme;
    final titleTextStyle = theme.appBarTheme.titleTextStyle;
    final bodyTextStyle = StandardTheme.getBodyTextStyle(context);

    return FormBox(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Photo",
            style: titleTextStyle,
          ),
          const ProductPhotoPicker(),
          Text(
            "Product Title",
            style: titleTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 20),
            child: TextFormField(
              controller: createNewProductBloc.form.name.notNullInput,
              validator: (value) => value?.isNotEmpty == true ? null : "",
              decoration: const InputDecoration(
                hintText: "Shoes etc...",
              ),
            ),
          ),
          Text(
            "Description",
            style: titleTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: TextFormField(
              controller: createNewProductBloc.form.description.notNullInput,
              maxLines: 5,
              minLines: 3,
              decoration: const InputDecoration(
                hintText: "Enter a description...",
              ),
            ),
          ),
          Text(
            "Describe your product attributes, sales points...",
            style: bodyTextStyle,
          ),
        ],
      ),
    );
  }
}

class ProductPhotoPicker extends StatelessWidget {
  const ProductPhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    return InkWell(
      onTap: () {
        createNewProductBloc.add(const CreateNewProductPickCoverPhotoEvent());
      },
      child: BlocBuilder<CreateNewProductBloc, SqliteExecuteBaseState>(
          buildWhen: (_, state) =>
              state is CreateNewProductCoverPhotoSelectedState,
          builder: (_, state) {
            if (createNewProductBloc.form.coverPhoto.input != null) {
              return Container(
                margin: const EdgeInsets.only(
                  top: 12,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(
                      File(createNewProductBloc.form.coverPhoto.notNullInput),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 80,
                height: 80,
                alignment: Alignment.center,
              );
            }
            return const UploadPhotoPlaceholder();
          }),
    );
  }
}

class UploadPhotoPlaceholder extends StatelessWidget {
  const UploadPhotoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 12,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: context.theme.unselectedWidgetColor,
        borderRadius: BorderRadius.circular(8),
      ),
      width: 80,
      height: 80,
      alignment: Alignment.center,
      child: const Icon(
        Icons.upload,
        size: 30,
      ),
    );
  }
}
