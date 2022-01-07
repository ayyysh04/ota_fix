import 'dart:async';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  var _gridViewHeight, _gridViewWidth;
  late ScrollController _scrollController;

  bool _showbottomRemoveBar = false;

  double? width;
  double? height;
  int? pos;
  var _isDragStart = false;
  final _formKey = GlobalKey<FormState>();
  StreamSubscription<Event>? devicesDataAddSubscription;
  StreamSubscription<Event>? devicesDataChangeSubscription;
  StreamSubscription<Event>? devicesDataRemoveSubscription;
  _moveUp() {
    _scrollController.animateTo(_scrollController.offset - _gridViewHeight,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  _moveDown() {
    _scrollController.animateTo(_scrollController.offset + _gridViewHeight,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    Query _devicesDataQuery = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuthData.auth.currentUser!.uid)
        .child("rooms")
        .child(roomModel.RoomListData.roomData![widget.roomIndex].roomID)
        .child("Devices")
        .orderByChild("pos");

    roomModel.RoomListData.roomData![widget.roomIndex].devicesData =
        []; //resets the device list when we open devices page
    devicesDataAddSubscription = _devicesDataQuery.onChildAdded.listen((event) {
      deviceModel.OnEntryAdded(event: event, roomIndex: widget.roomIndex);
    });
    devicesDataChangeSubscription =
        _devicesDataQuery.onChildChanged.listen((event) {
      deviceModel.OnEntryChanged(event: event, roomIndex: widget.roomIndex);
    });
    devicesDataRemoveSubscription =
        _devicesDataQuery.onChildRemoved.listen((event) {
      deviceModel.OnEntryRemoved(event: event, roomIndex: widget.roomIndex);
    });

    super.initState();
  }

  @override
  void dispose() {
    devicesDataAddSubscription?.cancel();
    devicesDataChangeSubscription?.cancel();
    devicesDataRemoveSubscription?.cancel();
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
            onPressed: () async {
              await customModalBottomSheet(context);
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
                          child: Stack(children: [
                            LayoutBuilder(builder: (context, constraints) {
                              _gridViewHeight = constraints.maxHeight;
                              _gridViewWidth = constraints.maxWidth;
                              return ScrollConfiguration(
                                behavior: const ScrollBehavior()
                                    .copyWith(overscroll: false),
                                child: GridView.builder(
                                        // physics: BouncingScrollPhysics(),
                                        controller: _scrollController,
                                        // dragStartBehavior: DragStartBehavior.start,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 0.9,
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                        ),
                                        itemCount: roomModel
                                            .RoomListData
                                            .roomData![widget.roomIndex]
                                            .devicesData!
                                            .length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return LayoutBuilder(builder:
                                              (BuildContext context,
                                                  BoxConstraints constraints) {
                                            height = constraints.minHeight;
                                            width = constraints.minWidth;
                                            return DragTarget(
                                              builder: (context, candidateData,
                                                  rejectedData) {
                                                return LongPressDraggable(
                                                  data: roomModel
                                                      .RoomListData
                                                      .roomData![
                                                          widget.roomIndex]
                                                      .devicesData?[index]
                                                      .key,
                                                  maxSimultaneousDrags: 1,
                                                  child: Opacity(
                                                      opacity: pos != null
                                                          ? pos == index
                                                              ? 0.6
                                                              : 1
                                                          : 1,
                                                      child: GestureDetector(
                                                        child: _gridItem(
                                                            index, context),
                                                        onTap: () {
                                                          if (roomModel
                                                                  .RoomListData
                                                                  .roomData![widget
                                                                      .roomIndex]
                                                                  .devicesData![
                                                                      index]
                                                                  .devicetype ==
                                                              "Fan") {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => FanScreen(
                                                                        roomIndex:
                                                                            widget
                                                                                .roomIndex,
                                                                        deviceIndex:
                                                                            index)));
                                                          }
                                                        },
                                                      )),
                                                  feedbackOffset: Offset(0, 0),
                                                  feedback:
                                                      _gridItem(index, context),
                                                  axis: null,
                                                  onDragEnd: (_) {
                                                    pos = null;
                                                    print("drag end");
                                                    setState(() {
                                                      _isDragStart = false;
                                                      _showbottomRemoveBar =
                                                          false;
                                                    });
                                                  },
                                                  onDragStarted: () {
                                                    print("drag started");
                                                    setState(() {
                                                      _isDragStart = true;
                                                      _showbottomRemoveBar =
                                                          true;
                                                    });
                                                  },
                                                  onDragCompleted: () {
                                                    print("drag completed");

                                                    setState(() {
                                                      _isDragStart = false;
                                                    });
                                                  },
                                                );
                                              },
                                              onWillAccept: (String? data) {
                                                if (data != null) {
                                                  int newIndex = index;

                                                  int indexOfFirstItem =
                                                      roomModel
                                                          .RoomListData
                                                          .roomData![
                                                              widget.roomIndex]
                                                          .devicesData!
                                                          .indexOf(roomModel
                                                              .RoomListData
                                                              .roomData![widget
                                                                  .roomIndex]
                                                              .devicesData!
                                                              .firstWhere(
                                                                  (element) {
                                                    if (element.key == data)
                                                      return true;
                                                    return false;
                                                  }));
                                                  int indexOfSecondItem = index;
                                                  if (indexOfSecondItem !=
                                                      indexOfFirstItem) {
                                                    if (indexOfFirstItem >
                                                        indexOfSecondItem) {
                                                      for (int i =
                                                              indexOfFirstItem;
                                                          i > indexOfSecondItem;
                                                          i--) {
                                                        var tmpPos = roomModel
                                                            .RoomListData
                                                            .roomData![widget
                                                                .roomIndex]
                                                            .devicesData![i - 1]
                                                            .pos;
                                                        var tmp = roomModel
                                                            .RoomListData
                                                            .roomData![widget
                                                                .roomIndex]
                                                            .devicesData![i - 1];
                                                        roomModel
                                                                .RoomListData
                                                                .roomData![widget
                                                                    .roomIndex]
                                                                .devicesData![i - 1]
                                                                .pos =
                                                            roomModel
                                                                .RoomListData
                                                                .roomData![widget
                                                                    .roomIndex]
                                                                .devicesData![i]
                                                                .pos;
                                                        roomModel
                                                                .RoomListData
                                                                .roomData![widget
                                                                    .roomIndex]
                                                                .devicesData![i - 1] =
                                                            roomModel
                                                                .RoomListData
                                                                .roomData![widget
                                                                    .roomIndex]
                                                                .devicesData![i];
                                                        roomModel
                                                            .RoomListData
                                                            .roomData![widget
                                                                .roomIndex]
                                                            .devicesData![i]
                                                            .pos = tmpPos;
                                                        roomModel
                                                                .RoomListData
                                                                .roomData![widget
                                                                    .roomIndex]
                                                                .devicesData![
                                                            i] = tmp;
                                                      }
                                                    } else {
                                                      for (int i =
                                                              indexOfFirstItem;
                                                          i < indexOfSecondItem;
                                                          i++) {
                                                        var tmpPos = roomModel
                                                            .RoomListData
                                                            .roomData![widget
                                                                .roomIndex]
                                                            .devicesData![i + 1]
                                                            .pos;
                                                        var tmp = roomModel
                                                            .RoomListData
                                                            .roomData![widget
                                                                .roomIndex]
                                                            .devicesData![i + 1];
                                                        roomModel
                                                                .RoomListData
                                                                .roomData![widget
                                                                    .roomIndex]
                                                                .devicesData![i + 1]
                                                                .pos =
                                                            roomModel
                                                                .RoomListData
                                                                .roomData![widget
                                                                    .roomIndex]
                                                                .devicesData![i]
                                                                .pos;
                                                        roomModel
                                                                .RoomListData
                                                                .roomData![widget
                                                                    .roomIndex]
                                                                .devicesData![i + 1] =
                                                            roomModel
                                                                .RoomListData
                                                                .roomData![widget
                                                                    .roomIndex]
                                                                .devicesData![i];
                                                        roomModel
                                                            .RoomListData
                                                            .roomData![widget
                                                                .roomIndex]
                                                            .devicesData![i]
                                                            .pos = tmpPos;
                                                        roomModel
                                                                .RoomListData
                                                                .roomData![widget
                                                                    .roomIndex]
                                                                .devicesData![
                                                            i] = tmp;
                                                      }
                                                    }
                                                  }
                                                  setState(
                                                    () {
                                                      pos = newIndex;
                                                    },
                                                  );
                                                  return true;
                                                }

                                                return false;
                                              },
                                              onAccept: (String data) {
                                                Map<String, dynamic> mapData =
                                                    Map<String,
                                                        dynamic>.fromIterable(
                                                  roomModel
                                                      .RoomListData
                                                      .roomData![
                                                          widget.roomIndex]
                                                      .devicesData!,
                                                  key: (e) => (e as deviceModel
                                                          .DeviceModel)
                                                      .key!,
                                                  value: (e) {
                                                    if (e.devicetype == "Fan") {
                                                      return {
                                                        'pos': e.pos,
                                                        'device name':
                                                            e.devicename,
                                                        'device type':
                                                            e.devicetype,
                                                        'status': e.status,
                                                        'switch no': e.switchno,
                                                        'speed': e.speed,
                                                      };
                                                    } else {
                                                      return {
                                                        'pos': e.pos,
                                                        'device name':
                                                            e.devicename,
                                                        'device type':
                                                            e.devicetype,
                                                        'status': e.status,
                                                        'switch no': e.switchno,
                                                      };
                                                    }
                                                  },
                                                );
                                                FirebaseDatabase.instance
                                                    .reference()
                                                    .child("users")
                                                    .child(FirebaseAuthData
                                                        .auth.currentUser!.uid)
                                                    .child("rooms")
                                                    .child(roomModel
                                                        .RoomListData
                                                        .roomData![
                                                            widget.roomIndex]
                                                        .roomID)
                                                    .child("Devices")
                                                    .update(mapData);
                                                // print(mapData);

                                                setState(
                                                  () {
                                                    pos = null;
                                                  },
                                                );
                                              },
                                            );
                                          });
                                        })
                                    // .hPCT(context: context, heightPCT: 70)
                                    .pOnly(left: 20, right: 20, top: 10),
                              );
                            }),
                            Visibility(
                              visible: _isDragStart,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: DragTarget(
                                  builder: (context,
                                          List<String?> candidateData,
                                          rejectedData) =>
                                      Container(
                                    height: 20,
                                    width: double.infinity,
                                    color: Colors.transparent,
                                  ),
                                  onWillAccept: (_) {
                                    _moveUp();
                                    return false;
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _isDragStart,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: DragTarget(
                                  builder: (context,
                                          List<String?> candidateData,
                                          rejectedData) =>
                                      Container(
                                    height: 20,
                                    width: double.infinity,
                                    color: Colors.transparent,
                                  ),
                                  onWillAccept: (_) {
                                    _moveDown();
                                    return false;
                                  },
                                ),
                              ),
                            ),
                          ]),
                        ))),
                Flexible(
                  flex: 1,
                  child: SizedBox.expand(
                    child: _showbottomRemoveBar
                        ? DragTarget(
                            onAccept: (data) //when onwillaccept returns true
                                async {
                              await FirebaseDatabase.instance
                                  .reference()
                                  .child("users")
                                  .child(FirebaseAuthData.auth.currentUser!.uid)
                                  .child("rooms")
                                  .child(roomModel.RoomListData
                                      .roomData![widget.roomIndex].roomID)
                                  .child("Devices")
                                  .child(data! as String)
                                  .remove()
                                  .whenComplete(() {
                                roomModel.RoomListData
                                    .roomData![widget.roomIndex].devicesData!
                                    .removeWhere((element) {
                                  if (element.key == data as String) {
                                    return true;
                                  }
                                  return false;
                                });
                              });
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
                                  onTap: () {
                                    roomModel.RoomListData
                                        .roomData![widget.roomIndex].devicesData
                                        ?.forEachIndexed((index, element) {
                                      deviceModel.ChangeStatus(
                                          roomIndex: widget.roomIndex,
                                          deviceIndex: index,
                                          deviceStatus: true);
                                    });
                                  },
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
                                  onTap: () {
                                    roomModel.RoomListData
                                        .roomData![widget.roomIndex].devicesData
                                        ?.forEachIndexed((index, element) {
                                      deviceModel.ChangeStatus(
                                          roomIndex: widget.roomIndex,
                                          deviceIndex: index,
                                          deviceStatus: false);
                                    });
                                  },
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
          deviceModel.OnEntryRemoved,
          // CreateSwitch
        },
      ),
    );
  }

  _gridItem(int index, BuildContext context) {
    return Container(
      width: width,
      height: height,
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

  Future customModalBottomSheet(BuildContext context) {
    FocusNode switchName = FocusNode();
    String? _deviceName;
    String? _deviceType;
    int? _switchno;
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
                void Function(void Function()) setStateModal) {
              return Container(
                  child: Form(
                // key: _formKey,
                child: Container(
                  child: DropdownButtonHideUnderline(
                    child: Column(
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        5.heightBox,
                        "New Button Config".text.xl3.bold.make(),
                        10.heightBox,
                        Icon(
                          (_deviceType == "Fan")
                              ? FontAwesomeIcons.fan
                              : Icons.lightbulb_rounded,
                          size: 120,
                        ),
                        10.heightBox,
                        TextFormField(
                          focusNode: switchName,
                          decoration: InputDecoration(
                            labelText: "Enter Switch Name",
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
                          onFieldSubmitted: (val) {
                            switchName.unfocus();
                          },
                          onChanged: (value) {
                            _deviceName = value;
                          },
                        ),
                        10.heightBox,
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
                              onTap: () {
                                switchName.unfocus();
                              },
                              onChanged: (String? value) {
                                setStateModal(() {
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
                              onTap: () {
                                switchName.unfocus();
                              },
                              onChanged: (value) {
                                setStateModal(() {
                                  _switchno = value;
                                });
                              }),
                        ),
                        10.heightBox,
                        ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Vx.gray600),
                            onPressed: () {
                              int sortPos = 0;
                              if (roomModel
                                  .RoomListData
                                  .roomData![widget.roomIndex]
                                  .devicesData!
                                  .isNotEmpty) {
                                sortPos = roomModel.RoomListData
                                    .roomData![widget.roomIndex].devicesData!
                                    .reduce((a, b) {
                                  return a.pos > b.pos ? a : b;
                                }).pos;
                              }

                              deviceModel.AddNewDevice(
                                  item: deviceModel.DeviceModel(
                                      pos: sortPos + 1,
                                      devicename: _deviceName!,
                                      devicetype: _deviceType!,
                                      status: false,
                                      switchno: _switchno!),
                                  roomID: roomModel.RoomListData
                                      .roomData![widget.roomIndex].roomID);
                              Navigator.pop(context);
                            },
                            child: "Create".text.xl2.bold.make()),
                      ],
                    ),
                  ),
                ).pSymmetric(v: 0, h: 20),
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
