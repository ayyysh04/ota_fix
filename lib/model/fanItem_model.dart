import 'package:ota_fix/model/deviceItem_model.dart';

class FanItem extends Item {
  int speed;
  double? knobvalue; //temprature value

  FanItem({
    name,
    // iconOn,
    // iconOff,
    active,
    // color,
    type,
    this.speed = 0,
    this.knobvalue = 0,
  }) : super(
          name: name,
          // iconOn: iconOn,
          // iconOff: iconOff,
          active: active,
          // color: color,
          type: type,
        );
}
