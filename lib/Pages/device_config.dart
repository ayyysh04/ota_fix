import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class DeviceConfig extends StatelessWidget {
  const DeviceConfig({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isdisable = true;
    return Scaffold(
      appBar: AppBar(
        title: "Device Configuration".text.make(),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //config gif
            Image.asset(
              "assets/gif/device_config.gif",
              width: 100,
              height: 100,
            ),
            //config text
            "Select your home wifi".text.xl.bold.make().py(5),
            "OTA fix needs to connect to your home WiFi".text.make().py(5),
            //next button
            50.heightBox,
            // if(devicewifi ==conncted in arduino)
            //  isdisable=false;

            ElevatedButton(
              onPressed: isdisable
                  ? null
                  : () {
                      //nextpage
                    },
              child: "Continue".text.make(),
            ),
          ],
        ).pOnly(top: 100),
      ),
    );
  }
}
