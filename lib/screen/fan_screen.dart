import 'package:flutter/material.dart';
import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/fanItem_model.dart';
import 'package:ota_fix/screen/component/on_off_widget.dart';
import 'package:ota_fix/screen/component/speed_widget.dart';
import 'package:ota_fix/screen/new%20fan/gesturedetector.dart';
import 'package:ota_fix/screen/new%20fan/tickerpainter.dart';
import 'package:velocity_x/velocity_x.dart';

class FanScreen extends StatelessWidget {
  final _vxClass = (VxState.store as Mystore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VxBuilder(
        mutations: {ChangeStatus, ChangeValue, ChangeSpeed},
        builder: (BuildContext context, store, VxStatus? status) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: getBackColor(_vxClass.myDevices[1].speed)!
                  //  getBackColor(_vxClass.myDevices[1].knobvalue)!,
                  ),
            ),
            child: SafeArea(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RawMaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        _vxClass.myDevices[1].name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Opacity(
                        opacity: 0,
                        child: RawMaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              )
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Container //outer round dimmed white circle
                                      //     (
                                      //   width: 260,
                                      //   height: 260,
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.white.withOpacity(0.2),
                                      //     shape: BoxShape.circle,
                                      //   ),
                                      // ),
                                      Container(
                                        height: 300,
                                        width: double.infinity,
                                        padding: EdgeInsets.all(80),
                                        child: CustomPaint(
                                          painter: TickPainter(
                                              currentRed: 5 *
                                                  _vxClass.myDevices[1]
                                                      .speed) //0-21 : 0 , 5 ,10 ,15,20
                                          ,
                                        ),
                                      ),
                                      Container(
                                          // height: 150,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          // width: double.infinity,
                                          //knob reading : 0 1 2 3
                                          //knob angle : 0 to pie
                                          child: CircleGestureDetector(
                                            knobReading: 3,
                                          )),
                                      // SemiCircleWidget //moving semiCircle using CustomPainter
                                      //     (
                                      //   diameter: 200,
                                      //   sweepAngle:
                                      //       ((_vxClass.myDevices[1].speedValue -
                                      //                   15) *
                                      //               12.0)
                                      //           .clamp(0.0, 180.0),
                                      //   color: getSliderColor(
                                      //       _vxClass.myDevices[1].speedValue),
                                      // ),
                                      // Container //inner solid round white circle
                                      //     (
                                      //   width: 200,
                                      //   height: 200,
                                      //   decoration: BoxDecoration(
                                      //       color: Colors.white,
                                      //       shape: BoxShape.circle,
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //           color: Colors.grey
                                      //               .withOpacity(0.3),
                                      //           spreadRadius: 5,
                                      //           blurRadius: 7,
                                      //           offset: Offset(0,
                                      //               3), // changes position of shadow
                                      //         ),
                                      //       ]),
                                      // ),
                                      // Text(
                                      //   '${convertToInt(_vxClass.myDevices[1].speedValue)}°C',
                                      //   style: TextStyle(
                                      //       fontSize: 60,
                                      //       fontWeight: FontWeight.w600),
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SpeedWidget(
                                    fanItem: _vxClass.myDevices[1],
                                  ),
                                  // Spacer(),
                                  10.heightBox,
                                  OnOffWidget(
                                    fanItem: _vxClass.myDevices[1] as FanItem,
                                  ),
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  // TemperatureWidget(
                                  //   fanItem: _vxClass.myDevices[1],
                                  //   onChanged: (value) {
                                  //     ChangeValue(value: value);
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  int convertToInt(double value) {
    return value.toInt();
  }

  List<Color>? getBackColor(int value) {
    if (value == 0) {
      return gradientGreen;
    } else if (value == 1) {
      return gradientTeal;
    } else if (value == 2) {
      return gradientBlue;
    } else if (value == 3) {
      return gradientViolet;
    } else if (value == 4) {
      return gradientRed;
    }
  }

  Color? getSliderColor(double value) {
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

    return newColor!;
  }
}

final gradientRed = [
  Color(0xFFff5252).withOpacity(0.2),
  Color(0xFFff1744).withOpacity(0.4),
  Color(0xFFff1744).withOpacity(0.4),
  Color(0xFFd50000).withOpacity(0.6),
];

final gradientViolet = [
  Color(0xFFE9E1FF),
  Color(0xFFD6C9FE),
  Color(0xFFD6C9FE),
  Color(0xFF784CFC).withOpacity(0.6),
];

final gradientBlue = [
  Color(0xFF448aff).withOpacity(0.2),
  Color(0xFF2979ff).withOpacity(0.4),
  Color(0xFF2979ff).withOpacity(0.4),
  Color(0xFF2962ff).withOpacity(0.6),
];

final gradientTeal = [
  Color(0xFF64ffda).withOpacity(0.2),
  Color(0xFF1de9b6).withOpacity(0.4),
  Color(0xFF1de9b6).withOpacity(0.4),
  Color(0xFF00bfa5).withOpacity(0.6),
];

final gradientGreen = [
  Color(0xFF69f0ae).withOpacity(0.2),
  Color(0xFF00e676).withOpacity(0.4),
  Color(0xFF00e676).withOpacity(0.4),
  Color(0xFF00c853).withOpacity(0.6),
];

const colorGreen = Color(0xFF00c853);
const colorTeal = Color(0xFF00bfa5);
const colorBlue = Color(0xFF2962ff);
const colorViolet = Color(0xFF784CFC);
const colorRed = Color(0xFFd50000);
