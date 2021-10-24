import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ota_fix/Pages/room_setup_page.dart';
import 'package:ota_fix/Utils/routes.dart';
import 'package:ota_fix/Utils/themes.dart';
import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/device_model.dart';
import 'package:ota_fix/model/room_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:websafe_svg/websafe_svg.dart';

class AddDevices extends StatelessWidget {
  String? _roomID; //roomID is arduino product unique id
  AddDevices({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // foregroundColor: Vx.black,
        automaticallyImplyLeading: true,
        title: "Add Device".text.color(Vx.black).make(),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Spacer(
            flex: 1,
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Device code text input
                _deviceCode(context),
                "or using QR code".text.xl.make(),
                15.heightBox,
                //Scan image
                _newDeviceImage()
              ],
            ),
          ),
          Spacer(
            flex: 5,
          ),
          MaterialButton(
            color: Vx.purple600,
            child: Container(
              child: "Continue".text.lg.color(Vx.white).make(),
            ),
            onPressed: () {
              if (_roomID != null) //validate using key form validator
              {
                (VxState.store as Mystore).tempDeviceID = _roomID!;
                Navigator.pushNamed(context, MyRoutes.deviceHotspotRoute);
              }
            },
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }

  _deviceCode(BuildContext context) {
    return Column(
      children: [
        "Add device using code :".text.xl.make(),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            hintText: "Enter Device code",
            labelText: "Device code",
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          ),
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            _roomID = value;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).unfocus();
          },
          validator: (value) => _deviceValidation(value),
        ).p(20),
      ],
    );
  }

  _deviceValidation(String? value) {
    if (value == null)
      return "Enter a valid code"; //Will be on product back side
    //send http request through arduino soft ap mode to check that device id entered is correct or not
    //more authentiaion code here
  }

  _newDeviceImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DottedBorder(
          color: Colors.orange,
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          strokeWidth: 1,
          child: Container(
            padding: EdgeInsets.all(50),
            color: Color.fromRGBO(255, 153, 0, 0.1),
            child: WebsafeSvg.asset(
                "assets/images/add_deivce.svg") //QR code on product,scan and pass the device id from it to verify the deivce id is correct or not
            ,
          ),
        ),
      ],
    );
  }
}
