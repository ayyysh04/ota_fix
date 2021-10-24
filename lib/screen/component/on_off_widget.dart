import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ota_fix/model/room_model.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/device_model.dart';
import 'package:ota_fix/model/fanItem_model.dart';
import 'package:ota_fix/screen/fan_screen.dart';

class OnOffWidget extends StatefulWidget {
  final int roomIndex;
  const OnOffWidget({
    Key? key,
    required this.roomIndex,
    required this.deviceIndex,
  }) : super(key: key);
  final int deviceIndex;

  @override
  _OnOffWidgetState createState() => _OnOffWidgetState();
}

class _OnOffWidgetState extends State<OnOffWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: getBackColor(RoomListData.roomData![widget.roomIndex]
            .devicesData![widget.deviceIndex].speed!),
      ),
      height: 100,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Power',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'OFF',
                    style: TextStyle(
                        fontSize: 16,
                        color: RoomListData.roomData![widget.roomIndex]
                                .devicesData![widget.deviceIndex].status
                            ? Colors.white
                            : Colors.white.withOpacity(0.3)),
                  ),
                  Text('/',
                      style: TextStyle(
                          fontSize: 16, color: Colors.white.withOpacity(0.3))),
                  Text('ON',
                      style: TextStyle(
                          fontSize: 16,
                          color: RoomListData.roomData![widget.roomIndex]
                                  .devicesData![widget.deviceIndex].status
                              ? Colors.white
                              : Colors.white.withOpacity(0.3))),
                ],
              ),
              CupertinoSwitch(
                activeColor: RoomListData.roomData![widget.roomIndex]
                        .devicesData![widget.deviceIndex].status
                    ? Colors.white54
                    : Colors.white.withOpacity(0.2),
                trackColor: RoomListData.roomData![widget.roomIndex]
                        .devicesData![widget.deviceIndex].status
                    ? Colors.white54
                    : Colors.white.withOpacity(0.1),
                value: RoomListData.roomData![widget.roomIndex]
                    .devicesData![widget.deviceIndex].status,
                onChanged: (value) {
                  ChangeStatus(
                      deviceStatus: value,
                      deviceIndex: widget.deviceIndex,
                      roomIndex: widget.roomIndex);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Color? getBackColor(int value) {
    Color? newColor;
    if (value == 0) {
      newColor = colorGreen;
    } else if (value == 1) {
      newColor = colorTeal;
    } else if (value == 2) {
      newColor = colorBlue;
    } else if (value == 3) {
      newColor = colorViolet;
    } else if (value == 4) {
      newColor = colorRed;
    }

    return newColor!.withOpacity(0.7);
  }
}
