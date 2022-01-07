import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ota_fix/Pages/login_page.dart';
import 'package:ota_fix/Utils/routes.dart';
import 'package:ota_fix/model/wifi_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class DeviceConfig extends StatefulWidget {
  DeviceConfig({Key? key}) : super(key: key);

  @override
  State<DeviceConfig> createState() => _DeviceConfigState();
}

class _DeviceConfigState extends State<DeviceConfig> {
  bool _isdisable = true;
  String? _password;
  Future<WifiModel?>? _wifiData;
  // WifiModel? wifiData;
  @override
  void initState() {
    super.initState();
    _wifiData = _getWifiData();
  }

  Future<WifiModel?> _getWifiData() async {
    var response;
    var response2;
    try {
      response = await http.get(Uri.parse('http://192.168.4.1/scan'));
    } on SocketException catch (e) {
      print(e);
    }
    WifiModel? wifiData;
    print('Response status: ${response2?.statusCode}');
    if (response?.statusCode == 200)
      wifiData = WifiModel.fromJson(response.body);

    //dummy Data
    // Map<String, dynamic> datain = {
    //   "Devices": [
    //     {"ssid": "Anita", "rssi": "-40", "security": "8"},
    //     {"ssid": "nita", "rssi": "-0", "security": "5"},
    //     {"ssid": "ta", "rssi": "-90", "security": "1"},
    //     {"ssid": "tata", "rssi": "-90", "security": "7"},
    //   ]
    // };
    // wifiData = WifiModel.fromMap(datain);
    // await Future.delayed(Duration(seconds: 5));
    return wifiData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: "Device Configuration".text.color(Colors.black).make(),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: 1,
            ),
            //config gif
            Image.asset(
              "assets/gif/device_config.gif",
              width: 100,
              height: 100,
            ),
            //config text
            "Select your home wifi".text.xl.bold.make().py(5),
            "OTA fix needs to connect to your home WiFi".text.make().py(5),
            //next button

            Spacer(
              flex: 1,
            ),
            Row(
              children: [
                Spacer(
                  flex: 1,
                ),
                "AVAILABLE NETWORKS ".text.make(),
                Divider(
                  thickness: 2,
                  color: Vx.gray400,
                ).expand(flex: 3),
                GestureDetector(
                  onTap: () {
                    //refresh list by sending request again

                    setState(() {
                      _wifiData = _getWifiData();
                    });
                  },
                  child: Icon(
                    Icons.refresh,
                    size: 30,
                  ),
                ),
                Spacer(
                  flex: 1,
                )
              ],
            ),

            Container(
              height: 300,
              width: 300,
              child: RefreshIndicator(
                onRefresh: () {
                  _wifiData = _getWifiData();
                  setState(() {});
                  return _wifiData!;
                },
                child: FutureBuilder<WifiModel?>(
                  future: _wifiData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      WifiModel wifiModelData = snapshot.data as WifiModel;

                      return ListView.separated(
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(
                                wifiModelData.devices![index].wifiIcon,
                                color: Vx.gray500,
                              ),
                              title: wifiModelData.devices![index].ssid.text
                                  .make(),
                              subtitle: wifiModelData
                                  .devices![index].security.text
                                  .make(),
                              onTap: () async {
                                await _showPasswordModalBottomSheet(context,
                                    wifiName:
                                        wifiModelData.devices![index].ssid);
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Vx.gray400,
                            );
                          },
                          itemCount: wifiModelData.devices?.length ?? 0);
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // CircularProgressIndicator().centered(),
                            // or
                            RefreshProgressIndicator().centered(),
                            10.heightBox,
                            "Scanning wifi networks".text.make()
                          ]);
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off_rounded,
                          size: 70,
                        ),
                        5.heightBox,
                        "Error cannot get wifi networks"
                            .text
                            .bold
                            .make()
                            .centered(),
                      ],
                    );
                  },
                ),
              ),
            ),
            Spacer(),
            // if(devicewifi ==conncted in arduino)
            //  isdisable=false;

            ElevatedButton(
              onPressed: _isdisable
                  ? null
                  : () {
                      // navigate to room name page
                      Navigator.pushNamed(context, MyRoutes.roomSetupRoute);
                    },
              child: "Continue".text.make(),
            ),
            Spacer(
              flex: 1,
            )
          ],
        ),
      ),
    );
  }

  _showPasswordModalBottomSheet(BuildContext scaffoldContext,
      {required String wifiName}) {
    bool _isobscure = true;
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: scaffoldContext,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setStateModal) {
              return Container(
                  // height: 320,
                  child: Form(
                // key: _formKey,
                child: Container(
                  child: DropdownButtonHideUnderline(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        wifiName.text.xl3.bold.make(),
                        10.heightBox,
                        Icon(
                          LineAwesomeIcons.wifi,
                          size: 80,
                        ),
                        10.heightBox,
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            children: [
                              TextFormField(
                                obscureText: _isobscure,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    child: Icon(_isobscure
                                        ? CupertinoIcons.eye_fill
                                        : CupertinoIcons.eye_slash_fill),
                                    onTap: () {
                                      setStateModal(() {
                                        _isobscure = !_isobscure;
                                      });
                                    },
                                  ),
                                  labelText: "Enter Password",
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Vx.gray400,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  _password = value;
                                },
                              ),
                              10.heightBox,
                              TextButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Vx.gray600),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    //use this and send it to the ardiono using http request
                                    // send http request of this wifi to arduino
                                    // if (http_request == device_connected) {
                                    //   isdisable == true;
                                    // }
                                    // eg
                                    http.Response? response;
                                    try {
                                      response = await http.get(Uri.parse(
                                          'http://192.168.4.1/setWifi?ssid=$wifiName&pass=$_password'));
                                      print(response.body);
                                    } on SocketException catch (e) {
                                      print(e);
                                    } on http.ClientException catch (e) {
                                      print(e);
                                    }
                                    if (_password != null &&
                                        response?.body == "Connected") {
                                      setState(() {
                                        print(_password);
                                        _isdisable = !_isdisable;
                                      });
                                    }

                                    CustomSnackBar(
                                        scaffoldContext,
                                        Text(response?.body ??
                                            "Cannot reach the Local Server"));
                                    // CreateSwitch(); //implemetn more
                                  },
                                  child: "Connect"
                                      .text
                                      .color(Colors.white)
                                      .xl2
                                      .bold
                                      .make())
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ).pSymmetric(v: 20, h: 20),
              ));
            },
          );
        });
  }
}
