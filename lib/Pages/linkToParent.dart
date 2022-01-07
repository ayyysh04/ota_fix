import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ota_fix/Utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';

class ConnectToParentAcc extends StatelessWidget {
  const ConnectToParentAcc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Vx.black,
        title: "No Deices added".text.make(),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Spacer(
              flex: 1,
            ),
            Icon(
              Icons.devices_rounded,
              size: 120,
            ),
            "You dont have any device added".text.xl.bold.make().centered(),
            20.heightBox,
            MaterialButton(
              color: Vx.purple600,
              textColor: Vx.white,
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  "Link to Parent account".text.lg.make(),
                  Icon(LineAwesomeIcons.link)
                ],
              ),
            ),
            "or".text.lg.bold.make(),
            MaterialButton(
              color: Vx.purple600,
              textColor: Vx.white,
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.deviceHotspotRoute);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: ["Add device".text.lg.make(), Icon(Icons.add)],
              ),
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
