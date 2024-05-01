import 'package:flutter/material.dart';

abstract class StandardTheme {
  Color get scaffoldBackgroundColor;
  Color get cardColor;
  Color get borderColor;
  Color get primaryColor;
  Color get outlinedButtonTextColor;
  Color get unselectedColor;

  ButtonStyle get buttonStyle;
  TextStyle get buttonTextStyle;

  BorderRadius get borderRadius;
  BorderSide get borderSide;

  ThemeData get ref => ThemeData.light();
  ThemeData get theme => ref.copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            side: borderSide,
          ),
        ),
        primaryColor: primaryColor,
        shadowColor: borderColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        cardColor: cardColor,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: borderRadius,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 1,
          backgroundColor: cardColor,
          showUnselectedLabels: true,
          unselectedItemColor: unselectedColor,
          selectedItemColor: Colors.black,
        ),
        cardTheme: CardTheme(
          color: cardColor,
          surfaceTintColor: cardColor,
          shadowColor: borderColor,
          shape: RoundedRectangleBorder(
            side: borderSide,
            borderRadius: borderRadius,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: buttonStyle.copyWith(
            foregroundColor: MaterialStatePropertyAll(primaryColor),
            shape: const MaterialStatePropertyAll(null),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: buttonStyle,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: buttonStyle.copyWith(
            backgroundColor: MaterialStatePropertyAll(primaryColor),
            foregroundColor: MaterialStatePropertyAll(cardColor),
          ),
        ),
      );
}

const Color lightScaffoldBackgroundColor = Color.fromRGBO(234, 236, 240, 1),
    lightCardColor = Color.fromRGBO(255, 255, 255, 1),
    lightBorderColor = Color.fromRGBO(208, 213, 221, 1),
    lightPrimaryColor = Color.fromRGBO(23, 92, 211, 1),
    lightOutlinedButtonTextColor = Color.fromRGBO(71, 84, 103, 1),
    lightUnselectedColor = Color.fromRGBO(154, 164, 178, 1);

const BorderRadius defaultBorderRadius = BorderRadius.all(Radius.circular(8));

class LightTheme extends StandardTheme {
  @override
  Color get scaffoldBackgroundColor => lightScaffoldBackgroundColor;
  @override
  Color get cardColor => lightCardColor;
  @override
  Color get borderColor => lightBorderColor;
  @override
  Color get primaryColor => lightPrimaryColor;
  @override
  Color get outlinedButtonTextColor => lightOutlinedButtonTextColor;
  @override
  Color get unselectedColor => lightUnselectedColor;

  @override
  BorderSide get borderSide => BorderSide(
        color: borderColor,
      );

  @override
  BorderRadius get borderRadius => defaultBorderRadius;

  @override
  TextStyle get buttonTextStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  @override
  ButtonStyle get buttonStyle => ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: borderSide,
          ),
        ),
        foregroundColor: MaterialStatePropertyAll(
          outlinedButtonTextColor,
        ),
        textStyle: MaterialStatePropertyAll(
          buttonTextStyle,
        ),
        elevation: const MaterialStatePropertyAll(0),
        overlayColor: MaterialStatePropertyAll(primaryColor.withOpacity(0.06)),
      );
}
