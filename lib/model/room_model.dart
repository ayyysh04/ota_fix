import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_database/firebase_database.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/device_model.dart';
import 'package:ota_fix/model/firebase_auth_utility.dart';

class AddRoom extends VxMutation<Mystore> {
  String roomName;
  AddRoom(this.roomName);
  @override
  perform() {
    // store!.noOfRoom = store!.noOfRoom++;
    //firebase add room
  }
}

class RoomModel {
  String
      roomID; //This should be unique and will be taken when we are configuring the nodemcu (nodemcu means room)
  String roomName;
  int roomType;
  List<DeviceModel>? devicesData;
  RoomModel({
    required this.roomID,
    required this.roomName,
    required this.roomType,
    this.devicesData,
  });

  Map<String, dynamic> toMap() {
    return {'room name': roomName, 'room type': roomType};
  }

  factory RoomModel.fromSnapshot(DataSnapshot snap) {
    return RoomModel(
      // devicesData: [],
      roomID: snap.key ??
          "null", //null means there is error in getting device unique id
      roomName: snap.value['room name'],
      roomType: snap.value['room type'],
    );
  }
}

class RoomListData {
  static List<RoomModel>? roomData;
}

class OnEntryAdded extends VxMutation<Mystore> {
  Event event;
  OnEntryAdded({
    required this.event,
  });
  @override
  perform() async {
    print("Entry added");

    RoomListData.roomData!.add(RoomModel.fromSnapshot(event.snapshot));
  }
}
