import 'package:flutter/material.dart';
import 'package:ota_fix/Pages/add_device.dart';
import 'package:ota_fix/Pages/device_wifi_config.dart';
import 'package:ota_fix/Pages/home_page.dart';
import 'package:ota_fix/Pages/login_page.dart';
import 'package:ota_fix/Pages/Dump_pages/XDSignupPage.dart';
import 'package:ota_fix/Pages/profile_page.dart';
import 'package:ota_fix/Pages/switches_page.dart';
import 'package:ota_fix/Pages/device_hotspot_connect.dart';
import 'package:ota_fix/Widgets/sign_in.dart';
import 'package:ota_fix/Widgets/sign_up.dart';
import 'package:ota_fix/screen/fan_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: LoginPage());
  }
}
