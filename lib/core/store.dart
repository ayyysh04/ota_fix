import 'package:velocity_x/velocity_x.dart';

import 'package:ota_fix/Utils/themes.dart';

//This will store all the models which are getting manupulated / very imp in our app
//I.e all the class objects are made here and accessed to the Vxstore
class Mystore extends VxStore {
  String tempDeviceID = "";
  int noOfRoom = 0;
  MyTheme? themeMode;
  //constructor ,We can also define them initially like done in above comments too
  Mystore() {
    themeMode = MyTheme();
  }
}
