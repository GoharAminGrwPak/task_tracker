import 'package:flutter/material.dart';
import 'package:task_tracker/core/common/colors/color_constants.dart';
final darkTheme = ThemeData(
  textTheme: TextTheme(
    titleMedium: TextStyle(color: Colors.white70),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  shadowColor: Colors.grey.shade900,
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: ColorConstants.mainColor,
    background: Color(0xFF333333),
    surface: Color(0xFF333333),
    onBackground: Colors.white,
    onPrimary: Colors.black,
  ),
  scaffoldBackgroundColor: Color(0xFF333333), // Using colorScheme.background instead
  appBarTheme: AppBarTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    backgroundColor: ColorConstants.mainColor, // Using colorScheme.primary instead
    elevation: 0,
    foregroundColor: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black, // Updated property name
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.grey), // Updated property name
  ),
);
final lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: ColorConstants.mainColor,
    background: Colors.white,
    surface: Colors.white,
    onBackground: Colors.black,
    onPrimary: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white, // Using colorScheme.background instead
  appBarTheme: AppBarTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    backgroundColor: ColorConstants.mainColor, // Using colorScheme.primary instead
    elevation: 0,
    foregroundColor: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black, // Updated property name
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.grey), // Updated property name
  ),
);