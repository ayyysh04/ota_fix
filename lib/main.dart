import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ota_fix/Pages/Dump_pages/signin_page.dart';
import 'package:ota_fix/Pages/add_device.dart';
import 'package:ota_fix/Pages/all_users_page.dart';
import 'package:ota_fix/Pages/device_wifi_config.dart';
import 'package:ota_fix/Pages/home_page.dart';
import 'package:ota_fix/Pages/login_page.dart';
import 'package:ota_fix/Pages/device_hotspot_connect.dart';
import 'package:ota_fix/Pages/room_setup_page.dart';
import 'package:ota_fix/Utils/routes.dart';
import 'package:ota_fix/Utils/themes.dart';
import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/device_model.dart';
import 'package:ota_fix/model/firebase_auth_utility.dart';
import 'package:ota_fix/model/firebase_database_utility.dart';
import 'package:ota_fix/model/firestore_utility.dart';
import 'package:ota_fix/model/room_model.dart';
import 'package:ota_fix/model/wifi_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_core/firebase_core.dart';
/*
Routing:

Login Page -> device hotspot connect -> add device -> device wifi config  ->room setup ->homepage
*/

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
        MyRoutes.allUsersRoute: (context) => AllUsersPage(),
        MyRoutes.deviceWiFiRoute: (context) => DeviceConfig(),
        MyRoutes.deviceHotspotRoute: (context) => WifiConnnectPage(),
        MyRoutes.roomSetupRoute: (context) => NewRoomConfig(),
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
    FirestoreUtility.intitilizeFirestore();
    FirebaseDatabaseUtility.intitilizeDatabase();
    await Future.delayed(Duration(seconds: 3));
    // for open homepage directyl if user is already sign in
    if (FirebaseAuthData.auth.currentUser != null) {
      return Future.value(HomePage());
    }

    return Future.value(LoginPage()); //loginpage will come
  }
}
