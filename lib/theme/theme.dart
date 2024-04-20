import 'package:flutter/material.dart';

abstract class StandardTheme {
  Color get scaffoldBackgroundColor;
  Color get cardColor;

  ThemeData get ref => ThemeData.dark();
  ThemeData get theme => ref.copyWith(
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        cardColor: cardColor,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      );
}

const Color lightCardColor = Color.fromRGBO(27, 42, 51, 1);

class LightTheme extends StandardTheme {
  @override
  Color get scaffoldBackgroundColor => const Color.fromRGBO(27, 47, 65, 1);
  @override
  Color get cardColor => lightCardColor;
}
