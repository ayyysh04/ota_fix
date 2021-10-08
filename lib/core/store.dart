import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ota_fix/model/fanItem_model.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:ota_fix/Utils/themes.dart';
import 'package:ota_fix/model/deviceItem_model.dart';

//This will store all the models which are getting manupulated / very imp in our app
//I.e all the class objects are made here and accessed to the Vxstore
class Mystore extends VxStore {
  List<dynamic> myDevices = [];

  MyTheme? themeMode;
  //constructor ,We can also define them initially like done in above comments too
  Mystore() {
    myDevices = deviceList;
    themeMode = MyTheme();
  }
}

class AddNewDevice extends VxMutation<Mystore> {
  DeviceType deviceType;
  dynamic item; //item or fanitem
  AddNewDevice({
    required this.deviceType,
  });
  @override
  perform() {
    store!.myDevices.add(item);
  }
}

class ActivateStatus extends VxMutation<Mystore> //Switch on/off any appliance
{
  int index;
  bool deviceStatus;
  ActivateStatus(this.index, this.deviceStatus);

  @override
  perform() {
    store!.myDevices[index].active = status;
  }
}

class ChangeStatus
    extends VxMutation<Mystore> //change on/off status of temprature widget only
{
  bool deviceStatus;
  ChangeStatus(this.deviceStatus);

  @override
  perform() {
    store!.myDevices[1].active = deviceStatus;
  }
}

class ChangeSpeed extends VxMutation<Mystore> {
  int value;
  ChangeSpeed(this.value); //changes speed : 1 2 3 4 of temprature widget only

  @override
  perform() {
    store!.myDevices[1].knobvalue = value * (pi / 3);

    store!.myDevices[1].speed = value;
  }
}

class ChangeValue extends VxMutation<Mystore> {
  double value;
  ChangeValue({
    required this.value,
  });
  @override
  perform() {
    store!.myDevices[1].knobvalue = value;
  }
}
