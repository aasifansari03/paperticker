import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:paperticker/services/models/tabProvider.dart';
import 'package:paperticker/settings/theme.dart';
import 'package:paperticker/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'pages/Home.dart';
import 'pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getApplicationDocumentsDirectory().then((Directory directory) async {
    File jsonFile = new File(directory.path + "/portfolio.json");
    if (jsonFile.existsSync()) {
      portfolioMap = json.decode(jsonFile.readAsStringSync());
    } else {
      jsonFile.createSync();
      jsonFile.writeAsStringSync("{}");
      portfolioMap = {};
    }
    if (portfolioMap == null) {
      portfolioMap = {};
    }
    jsonFile = new File(directory.path + "/marketData.json");
    if (jsonFile.existsSync()) {
      marketListData = json.decode(jsonFile.readAsStringSync());
    } else {
      jsonFile.createSync();
      jsonFile.writeAsStringSync("[]");
      marketListData = [];
      // getMarketData(); ?does this work?
    }
  });

  String themeMode = "Dark";
  bool darkOLED = true;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("shortenOn") != null &&
      prefs.getString("themeMode") != null) {
    shortenOn = prefs.getBool("shortenOn");
    themeMode = prefs.getString("themeMode");
    darkOLED = prefs.getBool("darkOLED");
  }

  runApp(new MyApp(themeMode, darkOLED));
}

class MyApp extends StatefulWidget {
  MyApp(this.themeMode, this.darkOLED);
  final themeMode;
  final darkOLED;

  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TabProvider(),
        ),
      ],
      child: MyAppChild(
        themeMode: widget.themeMode,
        darkOLED: widget.darkOLED,
      ),
    );
  }
}

class MyAppChild extends StatefulWidget {
  final themeMode;
  final darkOLED;
  const MyAppChild({Key key, this.themeMode, this.darkOLED}) : super(key: key);

  @override
  State<MyAppChild> createState() => _MyAppChildState();
}

class _MyAppChildState extends State<MyAppChild> {
  bool darkEnabled;
  String themeMode;
  bool darkOLED;

  void savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("themeMode", themeMode);
    prefs.setBool("shortenOn", shortenOn);
    prefs.setBool("darkOLED", darkOLED);
  }

  toggleTheme() {
    switch (themeMode) {
      // case "Automatic":
      //   themeMode = "Dark";
      //   break;
      case "Dark":
        themeMode = "Light";
        break;
      case "Light":
        // themeMode = "Automatic";
        themeMode = "Dark";
        break;
    }
    handleUpdate();
    savePreferences();
  }

  setDarkEnabled() {
    switch (themeMode) {
      case "Automatic":
        int nowHour = new DateTime.now().hour;
        if (nowHour > 6 && nowHour < 20) {
          darkEnabled = false;
        } else {
          darkEnabled = true;
        }
        break;
      case "Dark":
        darkEnabled = true;
        break;
      case "Light":
        darkEnabled = false;
        break;
    }
    setNavBarColor();
  }

  handleUpdate() {
    setState(() {
      setDarkEnabled();
    });
  }

  switchOLED({state}) {
    setState(() {
      darkOLED = state ?? !darkOLED;
    });
    setNavBarColor();
    savePreferences();
  }

  setNavBarColor() async {
    if (darkEnabled) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor:
              darkOLED ? darkThemeOLED.primaryColor : darkTheme.primaryColor));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: lightTheme.primaryColor));
    }
  }

  @override
  void initState() {
    super.initState();
    themeMode = widget.themeMode ?? "Automatic";
    darkOLED = widget.darkOLED ?? false;
    setDarkEnabled();
  }

  @override
  Widget build(BuildContext context) {
    isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    if (isIOS) {
      upArrow = "↑";
      downArrow = "↓";
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: darkEnabled
          ? darkOLED
              ? darkThemeOLED.primaryColor
              : darkTheme.primaryColor
          : lightTheme.primaryColor,
      title: "Trace",
      home: new Home(
        savePreferences: savePreferences,
        toggleTheme: toggleTheme,
        handleUpdate: handleUpdate,
        darkEnabled: darkEnabled,
        themeMode: themeMode,
        switchOLED: switchOLED,
        darkOLED: darkOLED,
      ),
      theme: darkEnabled
          ? darkOLED
              ? darkThemeOLED
              : darkTheme
          : lightTheme,
      routes: <String, WidgetBuilder>{
        "/settings": (BuildContext context) => new SettingsPage(
              savePreferences: savePreferences,
              toggleTheme: toggleTheme,
              darkEnabled: darkEnabled,
              themeMode: themeMode,
              switchOLED: switchOLED,
              darkOLED: darkOLED,
            ),
      },
    );
  }
}
