import 'package:flutter/material.dart';
import 'package:ota_fix/model/room_list_data.dart';
import 'package:velocity_x/velocity_x.dart';

class NewRoomConfig extends StatelessWidget {
  String? _roomName;
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
          RoomCardList(),
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
            onPressed: () {},
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

class RoomCardList extends StatefulWidget {
  const RoomCardList({Key? key}) : super(key: key);

  @override
  State<RoomCardList> createState() => _RoomCardListState();
}

class _RoomCardListState extends State<RoomCardList> {
  int _index = 0;
  ScrollController ctrl = ScrollController();
  List<RoomListData> roomImages = [
    RoomListData(
        roomImage: Image.asset("assets/images/room1.jpg"),
        roomName: "Living Room"),
    RoomListData(
        roomImage: Image.asset("assets/images/room2.jpg"),
        roomName: "Dining Room"),
    RoomListData(
        roomImage: Image.asset("assets/images/room3.jpg"),
        roomName: "Wash Room")
  ];

  @override
  Widget build(BuildContext context) {
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
            onPageChanged: (int index) => setState(() => _index = index),
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
        "Room type : ${roomImages[_index].roomName}".text.xl.make(),
      ],
    );
  }
}
