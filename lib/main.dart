import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ota_fix/Pages/Dump_pages/signin_page.dart';
import 'package:ota_fix/Pages/device_wifi_config.dart';
import 'package:ota_fix/Pages/home_page.dart';
import 'package:ota_fix/Pages/login_page.dart';
import 'package:ota_fix/Pages/device_hotspot_connect.dart';
import 'package:ota_fix/Utils/routes.dart';
import 'package:ota_fix/Utils/themes.dart';
import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/firebase_auth.dart';
import 'package:ota_fix/model/wifi_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(VxState(
    store: Mystore(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = (VxState.store as Mystore).themeMode!.themeMode;
    return MaterialApp(
      themeMode: themeMode,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      debugShowCheckedModeBanner: false,
      home: SplashScreenWidget(),
      routes: {
        MyRoutes.loginRoute: (context) => SigninPage(),
        MyRoutes.homeRoute: (context) => HomePage(),
      },
    );
  }
}

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      loaderColor: context.accentColor,
      backgroundColor: context.canvasColor,
      logo: Image.asset("assets/images/logo.png"),
      logoSize: 120,
      loadingText: Text(
        "Made in India",
      ),
      navigator: LoginPage(),
      futureNavigator: _futureNav(context),
    );
  }

  Future<Object>? _futureNav(context) async {
    await Firebase.initializeApp();
    FirebaseAuthData.auth = FirebaseAuth.instance;
    //for open homepage directyl if user is already sign in
    // if (FirebaseAuthData.auth.currentUser != null) {
    //   return Future.value(HomePage());
    // }
    (VxState.store as Mystore).firebaseData.intitilizeDatabase();
    await Future.delayed(Duration(seconds: 3));

    return Future.value(DeviceConfig());
  }
}
