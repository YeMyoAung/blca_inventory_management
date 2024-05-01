import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

Future<T?> dialog<T>(
  String title,
  content, {
  Function()? confirm,
}) =>
    StarlightUtils.dialog<T>(AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            confirm?.call() ?? StarlightUtils.pop();
          },
          child: const Text("Ok"),
        )
      ],
    ));
