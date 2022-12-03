import 'package:flutter/material.dart';

// Dark Theme

final ThemeData darkTheme = new ThemeData(
  primaryColor: Colors.white,
  brightness: Brightness.dark,
  textTheme: TextTheme(
    headline1: TextStyle(
        fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
    headline2: TextStyle(
        fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white),
    headline3: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
    bodyText1: TextStyle(fontSize: 14, color: Colors.white),
  ),
  // primaryColor: AppColors.primary,
  // scaffoldBackgroundColor: AppColors.darkScaffold, //1F1F1F
  appBarTheme: ThemeData.dark().appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            fontFamily: 'Jakarta',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
  // primaryColorDark: Colors.black,
  // colorScheme: const ColorScheme.dark(),
  bottomNavigationBarTheme: ThemeData.dark().bottomNavigationBarTheme.copyWith(
        elevation: 10,
        backgroundColor: Colors.grey[900],
        // selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.white,
      ),
  iconTheme: const IconThemeData(color: Colors.white),
  dividerColor: Colors.grey,
  fontFamily: 'Jakarta',

  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    textStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 14, color: Colors.white)),
  )),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      elevation: MaterialStateProperty.all(0),
      // backgroundColor: MaterialStateProperty.all(AppColors.primary),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
      textStyle: MaterialStateProperty.all(const TextStyle(
          fontSize: 14, color: Colors.white, fontFamily: 'Jakarta')),
    ),
  ),
);
//

//
//
//
//
//
//light theme
final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.black,
  brightness: Brightness.light,
  // primaryColor: AppColors.primary,
  textTheme: TextTheme(
    headline1: TextStyle(
        fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
    headline2: TextStyle(
        fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black),
    headline3: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
    bodyText1: TextStyle(fontSize: 14, color: Colors.black),
  ),

  // scaffoldBackgroundColor: AppColors.lightScaffold,
  appBarTheme: ThemeData.light().appBarTheme.copyWith(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            fontFamily: 'Jakarta',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
  // primaryColorLight: Colors.white,
  // colorScheme: const ColorScheme.light(),
  bottomNavigationBarTheme: ThemeData.light().bottomNavigationBarTheme.copyWith(
        backgroundColor: Colors.white,
        // selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey.shade700,
      ),
  iconTheme: const IconThemeData(color: Colors.black),
  dividerColor: Colors.grey,
  fontFamily: 'Jakarta',
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    textStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 14, color: Colors.black)),
  )),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
              TextStyle(color: Colors.white, fontFamily: 'Jakarta')),
          backgroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))))),
);
//

//
//

//

//

final ThemeData darkThemeOLED = new ThemeData(
  fontFamily: 'Jakarta',
  appBarTheme: ThemeData.dark().appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            fontFamily: 'Jakarta',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  backgroundColor: Colors.black,
  canvasColor: Colors.black,
  primaryColorLight: Colors.deepPurple[300],
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      elevation: MaterialStateProperty.all(0),
      backgroundColor: MaterialStateProperty.all(Colors.white),
      foregroundColor: MaterialStateProperty.all(Colors.black),
      padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
      textStyle: MaterialStateProperty.all(const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontFamily: 'Jakarta',
          fontWeight: FontWeight.w600)),
    ),
  ),
  cardColor: Color.fromRGBO(16, 16, 16, 1.0),
  dividerColor: Color.fromRGBO(20, 20, 20, 1.0),
  bottomAppBarColor: Color.fromRGBO(19, 19, 19, 1.0),
  dialogBackgroundColor: Colors.black,
  iconTheme: new IconThemeData(color: Colors.white),
);
