import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class WifiModel {
  List<Device>? devices;
  WifiModel({
    required this.devices,
  });

  factory WifiModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty || map["Devices"] == null) return WifiModel(devices: null);
    return WifiModel(
      devices: List<Device>.from(map['Devices']?.map((x) => Device.fromMap(x))),
    );
  }

  factory WifiModel.fromJson(String source) =>
      WifiModel.fromMap(json.decode(source));
}

class Device {
  final String ssid;
  final IconData wifiIcon;
  final String security;

  Device({required this.ssid, required this.wifiIcon, required this.security});

  factory Device.fromMap(Map<String, dynamic> map) {
    IconData _wifiIcon;
    String _security;
    if (map['security'] == 7) //open
    {
      _security = "open";
      if (int.parse(map['rssi']) > -50) {
        _wifiIcon = Icons.signal_wifi_4_bar;
      } else
        _wifiIcon = Icons.signal_wifi_0_bar;
    } else {
      _security = "secured";
      if (int.parse(map['rssi']) > -50) {
        _wifiIcon = Icons.signal_wifi_4_bar_lock;
      } else
        _wifiIcon = Icons.signal_wifi_0_bar;
    }
    return Device(
      ssid: map['ssid'],
      security: _security,
      wifiIcon: _wifiIcon,
    );
  }

  factory Device.fromJson(String source) => Device.fromMap(json.decode(source));
}




// Check
// Map<String, dynamic> datain = {
//       "Devices": [
//         {"ssid": "Anita", "rssi": "-50", "security": "8"},
//         {"ssid": "nita", "rssi": "-0", "security": "5"},
//         {"ssid": "ta", "rssi": "-90", "security": "1"}
//       ]
//     };

//     WifiModel wifiData = WifiModel.fromMap(datain);
