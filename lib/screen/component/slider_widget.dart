import 'package:flutter/material.dart';
import 'package:ota_fix/model/device_model.dart';
import 'package:ota_fix/model/fanItem_model.dart';
import 'package:ota_fix/model/room_model.dart';
import 'package:ota_fix/screen/fan_screen.dart';

class TemperatureWidget extends StatefulWidget {
  final int roomIndex;
  final int deviceIndex;
  const TemperatureWidget({
    required this.deviceIndex,
    Key? key,
    required this.roomIndex,
    @required this.onChanged,
  }) : super(key: key);
  final Function(double)? onChanged;

  @override
  _TemperatureWidgetState createState() => _TemperatureWidgetState();
}

class _TemperatureWidgetState extends State<TemperatureWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: getBackColor(RoomListData.roomData![widget.roomIndex]
            .devicesData![widget.deviceIndex].knobvalue!),
      ),
      // height: 100,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Temp',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '16°C',
                style: TextStyle(color: Colors.white),
              ),
              Expanded(
                child: Slider(
                  min: 16,
                  max: 30,
                  value: RoomListData.roomData![widget.roomIndex]
                      .devicesData![widget.deviceIndex].knobvalue!,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white.withOpacity(0.2),
                  onChanged: (value) {
                    setState(() {
                      widget.onChanged!(value);
                    });
                  },
                ),
              ),
              Text(
                '30°C',
                style: TextStyle(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  Color? getBackColor(double value) {
    int newValue = value.toInt();
    Color? newColor;
    if (newValue >= 16 && newValue < 19) {
      newColor = colorGreen;
    } else if (newValue >= 19 && newValue < 22) {
      newColor = colorTeal;
    } else if (newValue >= 22 && newValue < 25) {
      newColor = colorBlue;
    } else if (newValue >= 25 && newValue < 28) {
      newColor = colorViolet;
    } else if (newValue >= 28) {
      newColor = colorRed;
    }

    return newColor!.withOpacity(0.7);
  }
}
