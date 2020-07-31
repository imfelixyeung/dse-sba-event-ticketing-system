import 'package:flutter/material.dart';
import '../apis/database.dart';
import '../misc/hex_colour.dart';
import 'package:flutter/services.dart';

Color feliOrange = HexColour('#f9a825');
ShapeBorder feliCardShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0));

class FeliThemeChanger with ChangeNotifier {
  ThemeData get lightTheme => ThemeData(
        platform: TargetPlatform.android,
        appBarTheme: AppBarTheme(elevation: 0),
        popupMenuTheme: PopupMenuThemeData(color: Colors.grey.shade200),
        colorScheme: ColorScheme.light(primary: feliOrange),
        cardTheme: CardTheme(shape: feliCardShape, elevation: 0),
        accentColor: feliOrange,
        secondaryHeaderColor: feliOrange,
        primaryColor: feliOrange,
        brightness: Brightness.light,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: feliOrange,
        ),
        textTheme: TextTheme(headline6: TextStyle(color: feliOrange)),
      );

  ThemeData get darkTheme => ThemeData(
        platform: TargetPlatform.android,
        popupMenuTheme: PopupMenuThemeData(color: Colors.grey.shade700),
        appBarTheme: AppBarTheme(elevation: 0),
        bottomAppBarColor: Colors.grey.withAlpha(12),
        bottomAppBarTheme: BottomAppBarTheme(),
        colorScheme: ColorScheme.dark(primary: feliOrange),
        cardTheme: CardTheme(shape: feliCardShape, elevation: 0),
        accentColor: feliOrange,
        secondaryHeaderColor: feliOrange,
        brightness: Brightness.dark,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: feliOrange,
        ),
        textTheme: TextTheme(headline6: TextStyle(color: feliOrange)),
      );

  ThemeData get blackTheme => ThemeData(
        platform: TargetPlatform.android,
        popupMenuTheme: PopupMenuThemeData(color: Colors.grey.shade900),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme:
            AppBarTheme(color: Colors.black.withAlpha(25), elevation: 0),
        canvasColor: Colors.black,
        bottomAppBarColor: Colors.grey.withAlpha(32),
        colorScheme: ColorScheme.dark(primary: feliOrange),
        cardTheme: CardTheme(
            color: Colors.white10, shape: feliCardShape, elevation: 0),
        accentColor: feliOrange,
        secondaryHeaderColor: feliOrange,
        brightness: Brightness.dark,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: feliOrange,
          // elevation: preferredThemeElevation,
          // focusElevation: preferredThemeElevation * 1.25,
          // highlightElevation: preferredThemeElevation * 1.5,
        ),
        textTheme: TextTheme(headline6: TextStyle(color: feliOrange)),
        dialogBackgroundColor: Colors.grey.shade900,
      );

  FeliThemeChanger();

  setTheme() {
    notifyListeners();
  }

  ThemeData getTheme(String defaultScheme) {
    String preferredScheme = FeliStorageAPI().getColorScheme();

    switch (preferredScheme) {
      case 'automatic':
        // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        return defaultScheme == 'light' ? lightTheme : darkTheme;
      case 'light':
        // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        return lightTheme;
      case 'dark':
        // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        return darkTheme;
      case 'black':
        // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        return blackTheme;
        break;
      default:
    }
    return darkTheme;
  }
}
