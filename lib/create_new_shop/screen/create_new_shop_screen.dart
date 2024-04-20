import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewShopScreen extends StatelessWidget {
  const CreateNewShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final middleWidth = context.width * 0.18;
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
                decoration: const InputDecoration(
                  hintText: "Shop Name",
                ),
              ),
            ),
            SizedBox(
              width: context.width - 40,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                label: const Text("Create"),
                icon: const Icon(Icons.create),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShopCoverPhotoPicker extends StatefulWidget {
  const ShopCoverPhotoPicker({super.key});

  @override
  State<ShopCoverPhotoPicker> createState() => _ShopCoverPhotoPickerState();
}

class _ShopCoverPhotoPickerState extends State<ShopCoverPhotoPicker> {
  final ValueNotifier<String> imagePath = ValueNotifier("");

  @override
  void dispose() {
    imagePath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final xFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        imagePath.value = xFile?.path ?? "";
      },
      child: ValueListenableBuilder(
        valueListenable: imagePath,
        builder: (_, path, child) {
          return CircleAvatar(
            radius: 80,
            backgroundImage: path.isNotEmpty ? FileImage(File(path)) : null,
            child: path.isEmpty ? child : null,
          );
        },
        child: const Icon(Icons.image),
      ),
    );
  }
}
