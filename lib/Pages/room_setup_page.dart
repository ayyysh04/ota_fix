import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ota_fix/Utils/routes.dart';
import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/firebase_auth_utility.dart';
import 'package:ota_fix/model/firebase_database_utility.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:ota_fix/model/room_caursel_model.dart';
import 'package:ota_fix/model/room_model.dart';

class NewRoomConfig extends StatelessWidget {
  String? _roomName;
  int _index = 0;
  ScrollController ctrl = ScrollController();
  List<RoomCaurselModel> roomImages = [
    RoomCaurselModel(
        roomImage: Image.asset("assets/images/room1.jpg"),
        roomtype: "Living Room"),
    RoomCaurselModel(
        roomImage: Image.asset("assets/images/room2.jpg"),
        roomtype: "Dining Room"),
    RoomCaurselModel(
        roomImage: Image.asset("assets/images/room3.jpg"),
        roomtype: "Wash Room")
  ];
  NewRoomConfig({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "New Room Config".text.color(Vx.black).make(),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Spacer(
            flex: 1,
          ),
          StatefulBuilder(builder: (BuildContext context, setSliderState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                "Choose your room type".text.xl.make(),
                5.heightBox,
                Container(
                  height: MediaQuery.of(context).size.height * .25,
                  child: PageView.builder(
                    itemCount: roomImages.length,
                    controller: PageController(viewportFraction: 0.8),
                    onPageChanged: (int index) => setSliderState(() {
                      _index = index;
                    }),
                    itemBuilder: (context, index) {
                      return Transform.scale(
                        scale: index == _index ? 1 : 0.9,
                        child: Card(
                          elevation: 6,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            child: roomImages[index].roomImage,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                5.heightBox,
                "Room type : ${roomImages[_index].roomtype}".text.xl.make(),
              ],
            );
          }),
          Spacer(
            flex: 1,
          ),
          Container(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Enter Room Name",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Vx.gray400,
                    width: 2.0,
                  ),
                ),
              ),
              onChanged: (value) {
                _roomName = value;
              },
            ),
          ).pSymmetric(h: 20),
          MaterialButton(
            color: Vx.blue500,
            onPressed: () {
              if (_roomName != null) {
                RoomModel _newRoom = RoomModel(
                    roomID: (VxState.store as Mystore).tempDeviceID,
                    roomName: _roomName!,
                    roomType: _index,
                    devicesData: []);
                // RoomListData.roomData!.add(_newRoom);

                FirebaseDatabase.instance
                    .reference()
                    .child("users")
                    .child(FirebaseAuthData.auth.currentUser!.uid)
                    .child("rooms")
                    .child(_newRoom.roomID)
                    .set(_newRoom.toMap());
                Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
              }
            },
            child: Container(
              child: "Next".text.color(Vx.white).xl.make(),
            ),
          ),
          Spacer(
            flex: 5,
          )
        ],
      ),
    );
  }
}
