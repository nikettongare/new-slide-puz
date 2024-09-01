import 'package:flutter/material.dart';

class CustomThemes {
  static const Color primaryDarkColor = Color(0xff222831);
  static const Color secondaryDarkColor = Color(0xff393e46);
  static const Color primaryLightColor = Color(0xFFFBFFFF);
  static const Color secondaryLightColor = Color(0xFFFFFfff);

  static const Color tertiaryColor = Color(0xff00adb5);

  static Color placeholderText = Colors.grey.shade500;

  static const Color primaryDarkTextColor = primaryLightColor;
  static const Color secondaryDarkTextColor = secondaryLightColor;
  static const Color primaryLightTextColor = primaryDarkColor;
  static const Color secondaryLightTextColor = secondaryDarkColor;

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primaryDarkColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: primaryDarkColor,
      secondary: secondaryDarkColor,
      tertiary: tertiaryColor,
    ),
    primaryTextTheme: const TextTheme(
      titleLarge: TextStyle(
        color: tertiaryColor,
        fontSize: 30,
        fontWeight: FontWeight.w900,
      ),
      titleSmall: TextStyle(
        color: primaryDarkTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: TextStyle(
        color: secondaryDarkTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      fillColor: secondaryDarkColor,
      filled: true,
      hintStyle: TextStyle(
        color: placeholderText,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade500,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade400,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primaryLightColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: primaryLightColor,
      secondary: secondaryLightColor,
      tertiary: tertiaryColor,
    ),
    primaryTextTheme: const TextTheme(
      titleLarge: TextStyle(
        color: tertiaryColor,
        fontSize: 30,
        fontWeight: FontWeight.w900,
      ),
      titleSmall: TextStyle(
        color: primaryLightTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: TextStyle(
        color: secondaryLightTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      fillColor: secondaryLightColor,
      filled: true,
      hintStyle: TextStyle(
        color: placeholderText,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade500,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade400,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
    ),
  );
}
