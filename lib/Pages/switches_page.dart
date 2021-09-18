import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ota_fix/core/store.dart';
import 'package:velocity_x/velocity_x.dart';

class SwitchesPage extends StatefulWidget {
  final String roomName;
  SwitchesPage({
    Key? key,
    required this.roomName,
  }) : super(key: key);

  @override
  _SwitchesPageState createState() => _SwitchesPageState();
}

class _SwitchesPageState extends State<SwitchesPage> {
  String? _chosenValue;
  String? _chosenRelay;
  final _formKey = GlobalKey<FormState>();

  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: widget.roomName.text.bold.make(),
        centerTitle: true,
        leading: Icon(Icons.arrow_back_ios_new_rounded),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
              primary: Vx.gray400,
              // onPrimary: Colors.red,
            ),
            onPressed: () {
              customModalBottomSheet(context);
            },
            child: Icon(Icons.add),
          ).pOnly(right: 10),
        ],
      ),
      body: VxBuilder(
        builder: (context, _, __) {
          int noOfDevices = (VxState.store as Mystore).noOfDevices;
          return Container(
            child: Column(
              children: [
                Flexible(
                  flex: 8,
                  child: Container(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: noOfDevices,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            print("that button more features");
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            // margin: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _switchHead(),
                                Icon(
                                  status
                                      ? Icons.light_rounded
                                      : Icons.light_outlined,
                                  size: MediaQuery.of(context).size.width > 420
                                      ? 70
                                      : 0,
                                ),
                                "Room Light".text.bold.make()
                              ],
                            ).p(20),
                          ),
                        );
                      },
                    ),
                  )
                      // .hPCT(context: context, heightPCT: 70)
                      .pOnly(left: 20, right: 20, top: 10),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox.expand(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {},
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Vx.green300),
                              child: Container(
                                  // height: 70,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(),
                                  child: "Turn On all Devices".text.make()),
                            ),
                          ).pOnly(top: 10, bottom: 10, left: 15, right: 15),
                        ),
                        Expanded(
                          flex: 5,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {},
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Vx.red300),
                              child: Container(
                                  height: 70,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(),
                                  child: "Turn Off all Devices".text.make()),
                            ),
                          ).pOnly(top: 10, bottom: 10, left: 15, right: 15),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        mutations: {CreateSwitch},
      ),
    );
  }

  customModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Container(
                  child: Form(
                key: _formKey,
                child: Container(
                  child: DropdownButtonHideUnderline(
                    child: Column(
                      children: [
                        "New Button Config".text.xl3.bold.make(),
                        20.heightBox,
                        Icon(
                          (_chosenValue == "Fan")
                              ? FontAwesomeIcons.fan
                              : Icons.lightbulb_rounded,
                          size: 120,
                        ),
                        20.heightBox,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          // height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Vx.gray200,
                          ),
                          child: DropdownButton<String>(
                              focusColor: Colors.white,
                              value: _chosenValue,
                              //elevation: 5,
                              style: TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.black,
                              items: <String>[
                                'Fan',
                                'Light'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              hint: Text(
                                "Please choose a Device",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  _chosenValue = value;
                                });
                              }),
                        ),
                        10.heightBox,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          // height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Vx.gray200,
                          ),
                          child: DropdownButton<String>(
                              focusColor: Colors.white,
                              value: _chosenRelay,
                              //elevation: 5,
                              style: TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.black,
                              items: <String>[
                                'Realy 1',
                                'Relay 2',
                                'Relay 3',
                                'Relay 4',
                                'Realy 5'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              hint: Text(
                                "Please choose a relay",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  _chosenRelay = value;
                                });
                              }),
                        ),
                        10.heightBox,
                        ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Vx.gray600),
                            onPressed: () {
                              //Use vxstore

                              Navigator.pop(context);
                              CreateSwitch();
                            },
                            child: "Create".text.xl2.bold.make())
                      ],
                    ),
                  ),
                ).pSymmetric(v: 20, h: 20),
              ));
            },
          );
        });
  }

  _switchHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        status
            ? "ON".toString().text.bold.make()
            : "OFF".toString().text.bold.make(),
        CupertinoSwitch(
            value: status,
            onChanged: (val) {
              status = !status;
              setState(() {});
            })
      ],
    );
  }
}

class CreateSwitch extends VxMutation<Mystore> {
  @override
  perform() {
    store?.noOfDevices++;
  }
}
