import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/firebase_auth_utility.dart';
import 'package:ota_fix/model/room_model.dart';

class DeviceModel {
  String? key;
  String devicename;
  String devicetype;
  bool status;
  int switchno;
  int pos;
  int? speed; //for fan only
  double? knobvalue; //data from local storage only
  DeviceModel(
      {this.key,
      required this.devicename,
      required this.devicetype,
      required this.status,
      required this.switchno,
      this.speed,
      this.knobvalue, //data from local storage only
      required this.pos});

  Map<String, dynamic> toMapLight() {
    return {
      'pos': pos,
      'device name': devicename,
      'device type': devicetype,
      'status': status,
      'switch no': switchno,
    };
  }

  Map<String, dynamic> toMapChangeStatus({required bool changedStatus}) {
    return {
      'status': changedStatus,
    };
  }

  Map<String, dynamic> toMapChangeSpeed({required int speed}) {
    return {
      'speed': speed,
    };
  }

  Map<String, dynamic> toMapFan() {
    return {
      'pos': pos,
      'device name': devicename,
      'device type': devicetype,
      'status': status,
      'switch no': switchno,
      'speed': speed
    };
  }

  factory DeviceModel.fromSnapshot(DataSnapshot snap) {
    return DeviceModel(
      pos: snap.value['pos'],
      devicename: snap.value['device name'],
      devicetype: snap.value['device type'],
      status: snap.value['status'],
      switchno: snap.value['switch no'].toInt(),
      key: snap.key ??
          "null", //just avoid thte null ,in our database a key will always be there so it cant be null
      speed: snap.value['speed'] ?? null,
      knobvalue:
          snap.value['speed'] != null ? snap.value['speed'] * (pi / 4) : null,
    );
  }
}

// class DeviceData {
//   static List<DeviceModel>? devicesList;
// }
//callbacks
class OnEntryAdded extends VxMutation<Mystore> {
  int roomIndex;
  Event event;
  OnEntryAdded({
    required this.roomIndex,
    required this.event,
  });
  @override
  perform() async {
    print("Entry added");
    RoomListData.roomData![roomIndex].devicesData!.add(DeviceModel.fromSnapshot(
      event.snapshot,
    ));
  }
}

class OnEntryChanged extends VxMutation<Mystore> {
  int roomIndex;
  Event event;
  OnEntryChanged({
    required this.roomIndex,
    required this.event,
  });
  @override
  perform() {
    print("Entry changed");
    DeviceModel oldEntry = RoomListData.roomData![roomIndex].devicesData!
        .firstWhere((entry) //comparing changed data with data inside list
            {
      return entry.key == event.snapshot.key;
    });

    RoomListData.roomData![roomIndex].devicesData![
            RoomListData.roomData![roomIndex].devicesData!.indexOf(oldEntry)] =
        DeviceModel.fromSnapshot(event.snapshot);
  }
}

class OnEntryRemoved extends VxMutation<Mystore> {
  int roomIndex;
  Event event;
  OnEntryRemoved({
    required this.roomIndex,
    required this.event,
  });
  @override
  perform() {
    print("Entry removed");

    RoomListData.roomData![roomIndex].devicesData!.removeWhere((entry) {
      return entry.key == event.snapshot.key;
    });
  }
}

//Server calling methods
class AddNewDevice extends VxMutation<Mystore> {
  String roomID;
  DeviceModel item; //item or fanitem
  AddNewDevice({
    required this.roomID,
    required this.item,
  });
  @override
  perform() {
    if (item.devicetype == "Light") //light case
    {
      FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(FirebaseAuthData.auth.currentUser!.uid)
          .child("rooms")
          .child(roomID)
          .child("Devices")
          .push()
          .set(item.toMapLight());
    } else if (item.devicetype == "Fan") {
      item.speed = 0;
      item.knobvalue = 0;
      FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(FirebaseAuthData.auth.currentUser!.uid)
          .child("rooms")
          .child(roomID)
          .child("Devices")
          .push()
          .set(item.toMapFan());
    }
  }
}

class ChangeStatus extends VxMutation //Switch on/off any appliance
{
  int roomIndex;
  int deviceIndex;
  bool deviceStatus;
  ChangeStatus(
      {required this.deviceIndex,
      required this.deviceStatus,
      required this.roomIndex});
  @override
  perform() async {
    // print(DeviceData.devicesList![deviceIndex].key);
    await FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuthData.auth.currentUser!.uid)
        .child("rooms")
        .child(RoomListData.roomData![roomIndex].roomID)
        .child("Devices")
        .child(RoomListData.roomData![roomIndex].devicesData![deviceIndex].key!)
        .update(RoomListData.roomData![roomIndex].devicesData![deviceIndex]
            .toMapChangeStatus(changedStatus: deviceStatus));
  }
}

class ChangeSpeed extends VxMutation<Mystore> {
  int roomIndex;
  int deviceIndex;
  int value;
  ChangeSpeed(
      {required this.value,
      required this.deviceIndex,
      required this.roomIndex}); //changes speed : 1 2 3 4 of temprature widget only

  @override
  perform() {
    RoomListData.roomData![roomIndex].devicesData![deviceIndex].knobvalue =
        value * (pi / 4); //knob value

    // RoomListData.roomData![roomIndex].devicesData[deviceIndex].speed = value;
    FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuthData.auth.currentUser!.uid)
        .child("rooms")
        .child(RoomListData.roomData![roomIndex].roomID)
        .child("Devices")
        .child(RoomListData.roomData![roomIndex].devicesData![deviceIndex].key!)
        .update(RoomListData.roomData![roomIndex].devicesData![deviceIndex]
            .toMapChangeSpeed(speed: value));
  }
}

//callback methods for streamSubscription
class OnSpeedChanged extends VxMutation<Mystore> {
  int roomIndex;
  Event event;
  OnSpeedChanged({
    required this.roomIndex,
    required this.event,
  });
  @override
  perform() {
    print("Entry changed");
    DeviceModel oldEntry = RoomListData.roomData![roomIndex].devicesData!
        .firstWhere((entry) //comparing changed data with data inside list
            {
      return entry.key == event.snapshot.key;
    });

    RoomListData.roomData![roomIndex].devicesData![
            RoomListData.roomData![roomIndex].devicesData!.indexOf(oldEntry)] =
        DeviceModel.fromSnapshot(event.snapshot);
  }
}

class ChangeValue extends VxMutation<Mystore> {
  int roomIndex;
  int deviceIndex;
  double value;
  ChangeValue({
    required this.roomIndex,
    required this.deviceIndex,
    required this.value,
  });
  @override
  perform() {
    int degreeTemp = (value * (180 / pi)).toInt();
    print(degreeTemp);
    if (degreeTemp == 0) {
      ChangeSpeed(value: 0, deviceIndex: deviceIndex, roomIndex: roomIndex);
    } else if (degreeTemp >= 45 && degreeTemp < 90)
      ChangeSpeed(value: 1, deviceIndex: deviceIndex, roomIndex: roomIndex);
    else if (degreeTemp >= 90 && degreeTemp < 135)
      ChangeSpeed(value: 2, deviceIndex: deviceIndex, roomIndex: roomIndex);
    else if (degreeTemp >= 135 && degreeTemp < 179)
      ChangeSpeed(value: 3, deviceIndex: deviceIndex, roomIndex: roomIndex);
    else if (degreeTemp == 179)
      ChangeSpeed(value: 4, deviceIndex: deviceIndex, roomIndex: roomIndex);

    RoomListData.roomData![roomIndex].devicesData![deviceIndex].knobvalue =
        value;
  }
}
