import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

abstract class StandardTheme {
  static TextStyle getBodyTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: context.theme.appBarTheme.titleTextStyle?.color,
    );
  }

  Color get scaffoldBackgroundColor;
  Color get cardColor;
  Color get borderColor;
  Color get primaryColor;
  Color get tileColor;

  ///Title Text,
  Color get outlinedButtonTextColor;
  Color get unselectedColor;
  Color get unselectedWidgetColor;
  Color get iconColor;

  ButtonStyle get buttonStyle;
  TextStyle get buttonTextStyle;

  BorderRadius get borderRadius;
  BorderSide get borderSide;

  TextStyle get titleTextStyle => TextStyle(
        fontSize: 18,
        color: outlinedButtonTextColor,
        fontWeight: FontWeight.w500,
      );

  ThemeData get ref => ThemeData.light();
  ThemeData get theme => ref.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: titleTextStyle,
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
          isDense: true,
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
        listTileTheme: ListTileThemeData(
          tileColor: tileColor,
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: outlinedButtonTextColor,
          ),
        ),
        switchTheme: SwitchThemeData(
          trackOutlineWidth: const MaterialStatePropertyAll(0),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return primaryColor;
            }
            return unselectedWidgetColor;
          }),
          trackOutlineColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return primaryColor;
            }
            return unselectedWidgetColor;
          }),
        ),
        unselectedWidgetColor: unselectedWidgetColor,
        iconTheme: IconThemeData(
          color: iconColor,
        ),
      );
}

const Color lightScaffoldBackgroundColor = Color.fromRGBO(234, 236, 240, 1),
    lightCardColor = Color.fromRGBO(255, 255, 255, 1),
    lightBorderColor = Color.fromRGBO(208, 213, 221, 1),
    lightPrimaryColor = Color.fromRGBO(23, 92, 211, 1),
    lightOutlinedButtonTextColor = Color.fromRGBO(71, 84, 103, 1),
    lightUnselectedColor = Color.fromRGBO(154, 164, 178, 1),
    lightUnselectedWidgetColor = Color.fromRGBO(242, 244, 247, 1),
    lightIconColor = Color.fromRGBO(102, 112, 133, 1);
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
  Color get unselectedWidgetColor => lightUnselectedWidgetColor;
  @override
  Color get iconColor => lightIconColor;
  @override
  Color get tileColor => lightCardColor;

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
