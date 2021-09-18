import 'package:flutter/material.dart';
import 'package:ota_fix/Pages/add_device.dart';
import 'package:ota_fix/Pages/device_config.dart';
import 'package:ota_fix/Pages/home_page.dart';
import 'package:ota_fix/Pages/login_page.dart';
import 'package:ota_fix/Pages/XDSignupPage.dart';
import 'package:ota_fix/Pages/switches_page.dart';
import 'package:ota_fix/Pages/wifi_connect.dart';
import 'package:velocity_x/velocity_x.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: HomePage()
        // SwitchesPage(
        //   roomName: "BedRoom",
        // )
        );
  }
}
