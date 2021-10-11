import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:ota_fix/core/store.dart';

class AddRoom extends VxMutation<Mystore> {
  String roomName;
  AddRoom(this.roomName);
  @override
  perform() {
    store!.noOfRoom = store!.noOfRoom++;
    //firebase add room
  }
}
