import 'package:flutter/material.dart';
import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/fanItem_model.dart';
import 'package:ota_fix/screen/fan_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SpeedWidget extends StatelessWidget {
  const SpeedWidget({
    Key? key,
    @required this.fanItem,
  }) : super(key: key);
  final FanItem? fanItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: getBackColor(fanItem!.speed),
      ),
      // height: 100,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Speed',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RawMaterialButton(
                onPressed: fanItem!.active!
                    ? () {
                        ChangeSpeed(0);
                      }
                    : null,
                fillColor:
                    fanItem!.speed == 0 ? Colors.white : Colors.transparent,
                elevation: 0,
                constraints:
                    const BoxConstraints(minWidth: 38.0, minHeight: 38.0),
                child: Text(
                  '0',
                  style: TextStyle(
                      color: fanItem!.speed == 0 ? Colors.black : Colors.white,
                      fontSize: 18),
                ),
                shape: CircleBorder(side: BorderSide(color: Colors.white)),
              ),
              RawMaterialButton(
                onPressed: fanItem!.active!
                    ? () {
                        ChangeSpeed(1);
                      }
                    : null,
                fillColor:
                    fanItem!.speed == 1 ? Colors.white : Colors.transparent,
                elevation: 0,
                constraints:
                    const BoxConstraints(minWidth: 38.0, minHeight: 38.0),
                child: Text(
                  '1',
                  style: TextStyle(
                      color: fanItem!.speed == 1 ? Colors.black : Colors.white,
                      fontSize: 18),
                ),
                shape: CircleBorder(side: BorderSide(color: Colors.white)),
              ),
              RawMaterialButton(
                onPressed: fanItem!.active!
                    ? () {
                        ChangeSpeed(2);
                      }
                    : null,
                fillColor:
                    fanItem!.speed == 2 ? Colors.white : Colors.transparent,
                elevation: 0,
                constraints:
                    const BoxConstraints(minWidth: 38.0, minHeight: 38.0),
                child: Text(
                  '2',
                  style: TextStyle(
                      color: fanItem!.speed == 2 ? Colors.black : Colors.white,
                      fontSize: 18),
                ),
                shape: CircleBorder(side: BorderSide(color: Colors.white)),
              ),
              RawMaterialButton(
                onPressed: fanItem!.active!
                    ? () {
                        ChangeSpeed(3);
                      }
                    : null,
                fillColor:
                    fanItem!.speed == 3 ? Colors.white : Colors.transparent,
                elevation: 0,
                constraints:
                    const BoxConstraints(minWidth: 38.0, minHeight: 38.0),
                child: Text(
                  '3',
                  style: TextStyle(
                      color: fanItem!.speed == 3 ? Colors.black : Colors.white,
                      fontSize: 18),
                ),
                shape: CircleBorder(side: BorderSide(color: Colors.white)),
              ),
              RawMaterialButton(
                onPressed: fanItem!.active!
                    ? () {
                        ChangeSpeed(4);
                      }
                    : null,
                fillColor:
                    fanItem!.speed == 4 ? Colors.white : Colors.transparent,
                elevation: 0,
                constraints:
                    const BoxConstraints(minWidth: 38.0, minHeight: 38.0),
                child: Text(
                  '4',
                  style: TextStyle(
                      color: fanItem!.speed == 4 ? Colors.black : Colors.white,
                      fontSize: 18),
                ),
                shape: CircleBorder(side: BorderSide(color: Colors.white)),
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
