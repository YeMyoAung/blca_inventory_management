import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_bloc.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_event.dart';
import 'package:inventory_management_with_sql/create_new_shop/controller/create_new_shop_state.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewShopScreen extends StatelessWidget {
  const CreateNewShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final middleWidth = context.width * 0.18;
    final createNewShopBloc = context.read<CreateNewShopBloc>();
    return Scaffold(
      body: SafeArea(
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
                controller: createNewShopBloc.controller,
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
    );
  }
}

class CreateNewShopSubmitButton extends StatelessWidget {
  const CreateNewShopSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final createNewShopBloc = context.read<CreateNewShopBloc>();
    return ElevatedButton.icon(
      onPressed: () {
        createNewShopBloc.add(const CreateNewShopCreateShopEvent());
      },
      label: BlocConsumer<CreateNewShopBloc, CreateNewShopState>(
        listenWhen: (_, c) {
          return c is CreateNewShopCreatedState;
        },
        listener: (_, state) {
          logger.w("CreateShopSubitButton listener get an event");
          if (state is CreateNewShopCreatedState) {
            StarlightUtils.pop();
            StarlightUtils.snackbar(SnackBar(
                content:
                    Text("${createNewShopBloc.controller.text} was created.")));
            return;
          }
        },
        buildWhen: (_, c) {
          return c is CreateNewShopCreatingState ||
              c is CreateNewShopCreatedState ||
              c is CreateNewShopErrorState;
        },
        builder: (_, state) {
          logger.w("CreateShopSubitButton builder get an event");

          if (state is CreateNewShopCreatingState) {
            return const CupertinoActivityIndicator();
          }
          return const Text("Create");
        },
      ),
      icon: const Icon(Icons.create),
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
      child: BlocBuilder<CreateNewShopBloc, CreateNewShopState>(
        buildWhen: (p, c) {
          return p.coverPhotoPath?.split("/").last !=
              c.coverPhotoPath?.split("/").last;
        },
        builder: (_, state) {
          logger.w("ShopCoverPhotoPicker builder get an event");

          final path = state.coverPhotoPath ?? "";
          return CircleAvatar(
            radius: 80,
            backgroundImage: path.isNotEmpty ? FileImage(File(path)) : null,
            child: path.isEmpty ? const Icon(Icons.image) : null,
          );
        },
      ),
    );
  }
}
