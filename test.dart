import 'package:flutter/material.dart';

class CreateBloc {
  late final List<TextEditingController> controllers;
  CreateBloc(int textEditing, int userChoice) {
    controllers =
        List.generate(textEditing, (index) => TextEditingController());
  }
}

void main() async {
  // final createBloc = CreateBloc(5, 5);
  // print(createBloc.controllers);
}
