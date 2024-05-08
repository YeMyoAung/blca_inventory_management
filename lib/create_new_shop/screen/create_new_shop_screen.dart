import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/core/utils/dialog.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_event.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_state.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_with_form_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewShopScreen extends StatelessWidget {
  const CreateNewShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final middleWidth = context.width * 0.18;
    final createNewShopBloc = context.read<CreateNewShopBloc>();
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: createNewShopBloc.form.formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const IconButton(
                      onPressed: StarlightUtils.pop,
                      icon: Icon(Icons.arrow_back),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: middleWidth),
                      child: const Text(
                        "Create New Shop",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 10),
                child: ShopCoverPhotoPicker(),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  validator: (value) {
                    return value?.isNotEmpty == true
                        ? value?.contains("_") == true
                            ? "_ is not accept"
                            : null
                        : "Shop name is required";
                  },
                  controller: createNewShopBloc.form.name.input,
                  decoration: const InputDecoration(
                    hintText: "Shop Name",
                  ),
                ),
              ),
              SizedBox(
                width: context.width - 40,
                height: 55,
                child: const CreateNewShopSubmitButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CreateNewShopSubmitButton extends StatelessWidget {
  const CreateNewShopSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final createNewShopBloc = context.read<CreateNewShopBloc>();
    return ElevatedButton(
      onPressed: () {
        createNewShopBloc.add(const SqliteCreateEvent());
      },
      child: BlocConsumer<CreateNewShopBloc, SqliteCreateBaseState>(
        listenWhen: (_, c) {
          return c is SqliteCreatedState || c is SqliteCreateErrorState;
        },
        listener: (_, state) {
          logger.w("CreateShopSubitButton listener get an event");
          if (state is SqliteCreatedState) {
            StarlightUtils.pop();
            StarlightUtils.snackbar(SnackBar(
                content: Text(
                    "${createNewShopBloc.form.name.input?.text} was created.")));
            return;
          }
          state as SqliteCreateErrorState;
          dialog("Failed to create new shop", state.message);
        },
        buildWhen: (_, c) {
          return c is SqliteCreatingState ||
              c is SqliteErrorState ||
              c is SqliteCreatedState;
        },
        builder: (_, state) {
          logger.w("CreateShopSubitButton builder get an event");

          if (state is CreateNewShopCreatingState) {
            return const CupertinoActivityIndicator();
          }
          return const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Create Shop"),
              SizedBox(
                width: 5,
              ),
              Icon(Icons.add_circle_outline),
            ],
          );
        },
      ),
    );
  }
}

class ShopCoverPhotoPicker extends StatelessWidget {
  const ShopCoverPhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final createNewShopBloc = context.read<CreateNewShopBloc>();
    return GestureDetector(
      onTap: () {
        createNewShopBloc.add(const CreateNewShopPickCoverPhotoEvent());
      },
      child: BlocBuilder<CreateNewShopBloc, SqliteCreateBaseState>(
        builder: (_, state) {
          logger.w("ShopCoverPhotoPicker builder get an event");

          final path = createNewShopBloc.form.coverPhoto.input ?? "";
          if (path.isNotEmpty) {
            return CircleAvatar(
              radius: 80,
              backgroundImage: FileImage(File(path)),
            );
          }
          return Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(
                color: context.theme.shadowColor,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.image,
            ),
          );
        },
      ),
    );
  }
}
