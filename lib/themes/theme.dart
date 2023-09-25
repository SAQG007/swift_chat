import 'package:flutter/material.dart';

const fontFamily = "Quicksand Regular";

ThemeData theme = ThemeData(
  useMaterial3: true,
  fontFamily: fontFamily,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xff6750A4),
    onPrimary: Color(0xffFFFFFF),
    primaryContainer: Color(0xffEADDFF),
    onPrimaryContainer: Color(0xff21005D),
    secondary: Color(0xff625B71),
    onSecondary: Color(0xffFFFFFF),
    secondaryContainer: Color(0xffE8DEF8),
    onSecondaryContainer: Color(0xff1D192B),
    tertiary: Color(0xff7D5260),
    onTertiary: Color(0xffFFFFFF),
    tertiaryContainer: Color(0xffFFD8E4),
    onTertiaryContainer: Color(0xff31111D),
    error: Color(0xffB3261E),
    onError: Color(0xffFFFFFF),
    errorContainer: Color(0xffF9DEDC),
    onErrorContainer: Color(0xff410E0B),
    background: Color(0xffFFFBFE),
    onBackground: Color(0xff1C1B1F),
    surface: Color(0xffFFFBFE),
    onSurface: Color(0xff1C1B1F),
    outline: Color(0xff79747E),
    surfaceVariant: Color(0xffE7E0EC),
    onSurfaceVariant: Color(0xff49454F),
  ),
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      fontFamily: fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
  textTheme: const TextTheme(
    labelLarge: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
);
