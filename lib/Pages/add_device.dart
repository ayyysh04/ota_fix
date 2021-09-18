import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ota_fix/Utils/themes.dart';
import 'package:ota_fix/core/store.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:websafe_svg/websafe_svg.dart';

class AddDevices extends StatelessWidget {
  AddDevices({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: "Add Device".text.make(),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            //Device code text input
            _deviceCode(context),
            "Add device using code :".text.make(),

            //Scan image
            _newDeviceImage()
          ],
        ),
      ),
    );
  }

  _deviceCode(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        hintText: "Enter Device code",
        labelText: "Device code",
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).unfocus();
      },
      validator: (value) => _deviceValidation(value),
    ).p(20);
  }

  _deviceValidation(String? value) {
    if (value == null) return "Enter a valid code";
    //more authentiaion code here
  }

  _newDeviceImage() {
    return Column(
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
            child: WebsafeSvg.asset("/images/add_deivce.svg"),
          ),
        ),
      ],
    ).expand();
  }
}
