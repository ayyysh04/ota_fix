import 'dart:async';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ota_fix/model/device_model.dart' as deviceModel;
import 'package:ota_fix/model/firebase_auth_utility.dart';
import 'package:ota_fix/model/room_model.dart' as roomModel;
import 'package:ota_fix/screen/fan_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SwitchesPage extends StatefulWidget {
  final int roomIndex;
  SwitchesPage({
    required this.roomIndex,
  });

  @override
  _SwitchesPageState createState() => _SwitchesPageState();
}

class _SwitchesPageState extends State<SwitchesPage> {
  String? _deviceName = "opop";
  bool _showbottomRemoveBar = false;
  String? _deviceType;
  int? _switchno;
  final _formKey = GlobalKey<FormState>();
  StreamSubscription<Event>? devicesDataAddSubscription;
  StreamSubscription<Event>? devicesDataChangeSubscription;
  @override
  void initState() {
    Query _devicesDataAddQuery = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuthData.auth.currentUser!.uid)
        .child("rooms")
        .child(roomModel.RoomListData.roomData![widget.roomIndex].roomID)
        .child("Devices");
    Query _devicesDataChangeQuery = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuthData.auth.currentUser!.uid)
        .child("rooms")
        .child(roomModel.RoomListData.roomData![widget.roomIndex].roomID)
        .child("Devices");
    roomModel.RoomListData.roomData![widget.roomIndex].devicesData =
        []; //resets the device list when we open devices page
    devicesDataAddSubscription =
        _devicesDataAddQuery.onChildAdded.listen((event) {
      deviceModel.OnEntryAdded(event: event, roomIndex: widget.roomIndex);

      devicesDataChangeSubscription =
          _devicesDataChangeQuery.onChildChanged.listen((event) {
        deviceModel.OnEntryChanged(event: event, roomIndex: widget.roomIndex);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    devicesDataAddSubscription?.cancel();
    devicesDataChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: roomModel.RoomListData.roomData![widget.roomIndex].roomName.text
            .color(Colors.black)
            .bold
            .make(),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
              primary: Vx.gray400,
              // onPrimary: Colors.red,
            ),
            onPressed: () {
              customModalBottomSheet(context);
            },
            child: Icon(Icons.add),
          ).pOnly(right: 10),
        ],
      ),
      body: VxBuilder(
        builder: (context, _, __) {
          return Container(
            child: Column(
              children: [
                Flexible(
                  flex: 8,
                  child: GestureDetector(
                    onTap: () {
                      if (_showbottomRemoveBar == true)
                        setState(() {
                          _showbottomRemoveBar = false;
                        });
                    },
                    child: Container(
                      child: GridView.builder(
                        // dragStartBehavior: DragStartBehavior.start,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.9,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: roomModel.RoomListData
                            .roomData![widget.roomIndex].devicesData!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return LongPressDraggable(
                            maxSimultaneousDrags: 1,
                            onDragStarted: () {
                              setState(() {
                                _showbottomRemoveBar = true;
                              });
                            },
                            child: GestureDetector(
                              child: _gridItem(index, context),
                              onTap: () {
                                if (roomModel
                                        .RoomListData
                                        .roomData![widget.roomIndex]
                                        .devicesData![index]
                                        .devicetype ==
                                    "Fan") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FanScreen(
                                              roomIndex: widget.roomIndex,
                                              deviceIndex: index)));
                                }
                              },
                            ),
                            data: index, //dragged item index
                            feedbackOffset: Offset(0, 0),
                            feedback: _gridItem(index, context),
                          );
                        },
                      ),
                    )
                        // .hPCT(context: context, heightPCT: 70)
                        .pOnly(left: 20, right: 20, top: 10),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox.expand(
                    child: _showbottomRemoveBar
                        ? DragTarget(
                            onAccept: (data) //when onwillaccept returns true
                                {
                              print("accepted");
                            },
                            onWillAccept: (data) //Whether to accept or not
                                {
                              return false;
                            },
                            onLeave: (data) //when onwillaccept returns false
                                {
                              print("left");
                            },
                            builder: (BuildContext context,
                                List<Object?> candidateData,
                                List<dynamic> rejectedData) {
                              return Container(
                                color: Vx.gray200,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.remove_circle,
                                      size: 50,
                                      color: Vx.red400,
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded //use expanded or flexible
                                  (
                                flex: 5,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () {},
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Vx.green300),
                                    child: Container(
                                        // height: 70,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(),
                                        child:
                                            "Turn On all Devices".text.make()),
                                  ),
                                ).pOnly(
                                    top: 10, bottom: 10, left: 15, right: 15),
                              ),
                              Expanded(
                                flex: 5,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () {},
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Vx.red300),
                                    child: Container(
                                        height: 70,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(),
                                        child:
                                            "Turn Off all Devices".text.make()),
                                  ),
                                ).pOnly(
                                    top: 10, bottom: 10, left: 15, right: 15),
                              )
                            ],
                          ),
                  ),
                )
              ],
            ),
          );
        },
        mutations: {
          deviceModel.OnEntryAdded,
          deviceModel.OnEntryChanged,
          // CreateSwitch
        },
      ),
    );
  }

  _gridItem(int index, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.40,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        // margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _switchHead(roomIndex: widget.roomIndex, currentSwitchIndex: index),
            Icon(
              roomModel.RoomListData.roomData![widget.roomIndex]
                          .devicesData![index].devicetype ==
                      "Fan"
                  ? ((roomModel.RoomListData.roomData![widget.roomIndex]
                          .devicesData![index].status
                      ? CommunityMaterialIcons.fan
                      : CommunityMaterialIcons.fan_off))
                  : roomModel.RoomListData.roomData![widget.roomIndex]
                              .devicesData![index].devicetype ==
                          "Light"
                      ? (roomModel.RoomListData.roomData![widget.roomIndex]
                              .devicesData![index].status
                          ? CommunityMaterialIcons.lightbulb
                          : CommunityMaterialIcons.lightbulb_off)
                      : null,
              size: MediaQuery.of(context).size.height > 250 ? 70 : 0,
            ),
            roomModel.RoomListData.roomData![widget.roomIndex]
                .devicesData![index].devicename.text.bold
                .make()
          ],
        ).p(20),
      ),
    );
  }

  customModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Container(
                  child: Form(
                key: _formKey,
                child: Container(
                  child: DropdownButtonHideUnderline(
                    child: Column(
                      children: [
                        "New Button Config".text.xl3.bold.make(),
                        20.heightBox,
                        Icon(
                          (_deviceType == "Fan")
                              ? FontAwesomeIcons.fan
                              : Icons.lightbulb_rounded,
                          size: 120,
                        ),
                        20.heightBox,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          // height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Vx.gray200,
                          ),
                          child: DropdownButton<String>(
                              focusColor: Colors.white,
                              value: _deviceType,
                              //elevation: 5,
                              style: TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.black,
                              items: <String>[
                                'Fan',
                                'Light'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              hint: Text(
                                "Please choose a Device",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  _deviceType = value;
                                });
                              }),
                        ),
                        10.heightBox,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          // height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Vx.gray200,
                          ),
                          child: DropdownButton<int>(
                              focusColor: Colors.white,
                              value: _switchno,
                              //elevation: 5,
                              style: TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.black,
                              items: <int>[1, 2, 3, 4, 5]
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(
                                    value.toString(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              hint: Text(
                                "Please choose a relay",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _switchno = value;
                                });
                              }),
                        ),
                        10.heightBox,
                        ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Vx.gray600),
                            onPressed: () {
                              //Use vxstore
                              deviceModel.AddNewDevice(
                                  item: deviceModel.DeviceModel(
                                      devicename: _deviceName!,
                                      devicetype: _deviceType!,
                                      status: false,
                                      switchno: _switchno!),
                                  roomID: roomModel.RoomListData
                                      .roomData![widget.roomIndex].roomID);
                              Navigator.pop(context);
                            },
                            child: "Create".text.xl2.bold.make())
                      ],
                    ),
                  ),
                ).pSymmetric(v: 20, h: 20),
              ));
            },
          );
        });
  }

  _switchHead({required int currentSwitchIndex, required int roomIndex}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        roomModel.RoomListData.roomData![widget.roomIndex]
                .devicesData![currentSwitchIndex].status
            ? "ON".toString().text.bold.make()
            : "OFF".toString().text.bold.make(),
        CupertinoSwitch(
            value: roomModel.RoomListData.roomData![widget.roomIndex]
                .devicesData![currentSwitchIndex].status,
            onChanged: (val) {
              deviceModel.ChangeStatus(
                  roomIndex: roomIndex,
                  deviceIndex: currentSwitchIndex,
                  deviceStatus: val);
            })
      ],
    );
  }
}

// class CreateSwitch extends VxMutation<Mystore> {
//   @override
//   perform() {
//     // store?.noOfDevices++;
//   }
// }
