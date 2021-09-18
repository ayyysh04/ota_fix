import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:ota_fix/Pages/signin_page.dart';
import 'package:ota_fix/Utils/routes.dart';
import 'package:ota_fix/Utils/themes.dart';
import 'package:ota_fix/core/store.dart';
import 'package:velocity_x/velocity_x.dart';

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
      navigator: SigninPage(),
      durationInSeconds: 2,
    );
  }
}
