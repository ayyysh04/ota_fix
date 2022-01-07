import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:ota_fix/Pages/login_page.dart';
import 'package:ota_fix/Utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:wifi_iot/wifi_iot.dart';

class WifiConnnectPage extends StatelessWidget {
  bool _isConnected = false;
  connectToWifi() async {
    _isConnected =
        await WiFiForIoTPlugin.connect(accessPoint!, password: password);
  }

  final info = NetworkInfo();
  WifiConnnectPage({Key? key}) : super(key: key);
  //These data comming from arduino
  final String? accessPoint = "Harshit vai";
  final String? password = "";
  @override
  Widget build(BuildContext context) {
    connectToWifi();
    return Scaffold(
      appBar: AppBar(
        title: "Wifi Config".text.color(Colors.black).make(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            "Connect to device wifi to continue..."
                .text
                .xl2
                .bold
                .make()
                .centered()
                .pOnly(
                  top: 50,
                ),
            10.heightBox,
            //Wifi Config Image
            Image.asset(
              "assets/images/wifi_config.png",
              height: 350,
              width: 200,
            ),
            //Details
            "Configure it with these details".text.make(),
            10.heightBox,
            //Config screen
            SizedBox(
              width: 350,
              child: Card(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Access point name".text.color(Vx.gray400).make(),
                        if (accessPoint != null)
                          accessPoint!.text.make()
                        else
                          "No value recieved".text.make()
                      ],
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Password".text.color(Vx.gray400).make(),
                        if (password != null)
                          password!.text.make()
                        else
                          "No value recieved".text.make()
                      ],
                    )
                  ],
                ).pSymmetric(v: 10, h: 10),
              ),
            ),
            30.heightBox,

            ElevatedButton(
                onPressed: () async {
                  if (Platform.isAndroid) {
                    var status = await Permission.location.status;
                    if (status.isDenied) {
                      if (await Permission.location.request().isGranted) {
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Loaction Permission'),
                                content: Text(
                                    'This app needs Loaction access to check WiFi Status\nCan be denied after the device setup'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Deny'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                    child: Text('Settings'),
                                    onPressed: () {
                                      openAppSettings();

                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      }
                    } else {
                      if (!_isConnected) {
                        CustomSnackBar(
                            context,
                            Text(
                                "Cannot connect to WiFi ,Try connecting manually"));
                      }
                      String? wifiName = await info.getWifiName();
                      if (wifiName != accessPoint) {
                        print(wifiName);
                        CustomSnackBar(
                            context,
                            Text(
                                "You are not connected to the device hotspot,Retry!!!"));
                      } else
                        Navigator.pushNamed(context, MyRoutes.deviceWiFiRoute);
                    }
                  }
                },
                child: Container(
                  child:
                      "Continue".text.xl2.bold.make().pSymmetric(h: 30, v: 10),
                )),
          ],
        ),
      ),
    );
  }
}
