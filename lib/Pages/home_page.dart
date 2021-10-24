import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ota_fix/Utils/routes.dart';
import 'package:ota_fix/Widgets/custom_bottom_navbar.dart';
import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/device_model.dart' as deviceModel;
import 'package:ota_fix/model/firebase_auth_utility.dart';
import 'package:ota_fix/model/room_model.dart' as roomModel;
import 'package:velocity_x/velocity_x.dart';

import 'package:ota_fix/Pages/power_usage_page.dart';
import 'package:ota_fix/Pages/profile_page.dart';
import 'package:ota_fix/Pages/switches_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _chosenValue;
  late PageController pageController;
  int _currentPage = 0;
  // late StreamSubscription<Event> userIdDataAddSubscription;
  // late StreamSubscription<Event> userRoomDataChangeSubscription;
  late StreamSubscription<Event> userDeviceDataAddSubscription;
  late StreamSubscription<Event> userDeviceDataChangeSubscription;
  late StreamSubscription<Event> roomDataAddSubscription;
  @override
  void initState() {
    super.initState();
    roomModel.RoomListData.roomData = [];
    pageController = PageController(initialPage: 0);
    Query _roomDataQuery = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuthData.auth.currentUser!.uid)
        .child("rooms");
    roomDataAddSubscription = _roomDataQuery.onChildAdded.listen((event) {
      roomModel.OnEntryAdded(event: event);
    });
    // Query _devicesDataQuery = FirebaseDatabase.instance
    //     .reference()
    //     .child("users")
    //     .child(FirebaseAuthData.auth.currentUser!.uid)
    //     .child("rooms")
    //     .child("room1")
    //     .child("Devices")
    //     .orderByKey();
    // userDeviceDataAddSubscription =
    //     _devicesDataQuery.onChildAdded.listen((event) {
    //   deviceModel.OnEntryAdded(event: event);
    // });
    // userDeviceDataChangeSubscription =
    //     _devicesDataQuery.onChildChanged.listen((event) {
    //   deviceModel.OnEntryChanged(event: event);
    // });

    // Query _userdIdQuery = FirebaseDatabase.instance
    //     .reference()
    //     .child("users")
    //     .child(FirebaseAuthData.auth.currentUser!.uid)
    //     .child("rooms")
    //     .child(
    //         "room1") //get the roomname from listview of rooms currently shown on screen to save the stream/data  (note that rooms are nodemcu)
    //     .child("Devices")
    //     .orderByKey();
    //Stream at devices to get that particular device data only

    // Query _userRoomNameQuerey = FirebaseDatabase.instance
    // .reference()
    // .child("users")
    // .child(FirebaseAuthData.auth.currentUser!.uid)
    // .child("rooms")
    // .equalTo("$roomno")//get the roomname from listview of rooms currently shown on screen to save the stream/data  (note that rooms are nodemcu)
    // .child("roomname").orderByKey();

    // Query _userdRoomQuery = FirebaseDatabase.instance
    //     .reference()
    //     .child("users")
    //     .child(FirebaseAuthData.auth.currentUser!.uid)
    //     .child("rooms");
    // userIdDataAddSubscription = _userdIdQuery.onChildChanged.listen(
    //     (event) //print all the values first time and then when child gets added ,only the child added part will come
    //     {
    //   print(event.snapshot.value);
    // });

//rooms
    // userRoomDataChangeSubscription = _userdRoomQuery.onChildAdded.listen(
    //     (event) //print all the values first time and then when child gets added ,only the child added part will come
    //     {
    //   print(event.snapshot.value);
    // });
  }

//unique switch no

  @override
  void dispose() {
    // userIdDataAddSubscription.cancel();
    // userRoomDataChangeSubscription.cancel();
    userDeviceDataAddSubscription.cancel();
    userDeviceDataChangeSubscription.cancel();
    roomDataAddSubscription.cancel();
    super.dispose();
  }

  double temp = 23.5;

  int humPer = 79;

  double powerUsage = 45.4;

  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    // deviceModel.DeviceData.devicesList!.forEach((element) {
    //   print(element.devicename);
    //   print(element.devicetype);
    //   print(element.key);
    //   print(element.speed);
    //   print(element.status);
    //   print(element.switchno);
    //   print("----------");
    // });
    // int? _selectedIndex = (VxState.store as Mystore).selectedIndex;
    // VxState.watch(context, on: [OnItemTapped]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.transparent,
      body: PageView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: pageController,
        onPageChanged: (value) {
          setState(() {
            _currentPage = value;
          });
        },
        children: [_homepage(), powerUsagePage(), ProfilePage()],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
      //  BottomNavigationBar(
      //   currentIndex: _currentPage,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   items: [
      //     BottomNavigationBarItem(
      //         activeIcon: Icon(Icons.home, size: 30),
      //         icon: Icon(Icons.home_outlined, size: 30),
      //         label: "Home",
      //         backgroundColor: Colors.transparent),
      //     BottomNavigationBarItem(
      //         activeIcon: Icon(CupertinoIcons.bolt_fill, size: 30),
      //         icon: Icon(CupertinoIcons.bolt, size: 30),
      //         label: "Power Usage",
      //         backgroundColor: Colors.transparent),
      //     BottomNavigationBarItem(
      //       activeIcon: Icon(FontAwesomeIcons.userAlt, size: 30),
      //       icon: Icon(
      //         FontAwesomeIcons.user,
      //         size: 30,
      //       ),
      //       label: "User profile",
      //     ),
      //   ],
      // ),
    );
  }

  Widget _homepage() {
    // deviceModel.DeviceData.devicesList!.forEach((element) {
    //   print(element.devicename);
    //   print(element.devicetype);
    //   print(element.key);
    //   print(element.speed);
    //   print(element.status);
    //   print(element.switchno);
    //   print("----------");
    // });
    return Container(
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible //Flexible and expandable are almost same
              (
            fit: FlexFit.tight,
            flex: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                        child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.cover,
                    )).wh(100, 70),
                    "OTA Fix"
                        .text
                        .xl5
                        .color(Vx.black)
                        .fontFamily(GoogleFonts.varelaRound().fontFamily!)
                        .bold
                        .blue500
                        .make(),
                  ],
                ),
                _upperIconsWidget(),
                // _uppperCardWidgets(),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 3,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Spacer(
                        flex: 2,
                      ),
                      "Rooms".text.xl2.bold.make(),
                      Spacer(
                        flex: 1,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                          primary: Vx.gray400,
                          // onPrimary: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context,
                              MyRoutes
                                  .deviceHotspotRoute); //navigate to wifi connect
                          //room means new nodemcu so we will be requiring to configure a new nodemcu for that
                        },
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                  5.heightBox,
                  RoomSliderWidget(
                    constraints: constraints,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    ).pOnly(top: 20, left: 15, right: 15, bottom: 0);
  }

  _customModalBottomSheet(BuildContext scaffoldContext) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: scaffoldContext,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              String? _chosenValue;
              return Container(
                  // height: 320,
                  child: Form(
                // key: _formKey,
                child: Container(
                  child: DropdownButtonHideUnderline(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        "New Room Config".text.xl3.bold.make(),
                        20.heightBox,
                        Icon(
                          FontAwesomeIcons.laptopHouse,
                          size: 90,
                        ),
                        10.heightBox,
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: TextFormField(),
                        ),
                        10.heightBox,
                        TextButton(
                            style:
                                ElevatedButton.styleFrom(primary: Vx.gray600),
                            onPressed: () {
                              //Use vxstore
                              roomModel.AddRoom("My new room");
                              Navigator.pop(context);
                              // CreateSwitch(); //implemetn more
                            },
                            child: "Create"
                                .text
                                .color(Colors.white)
                                .xl2
                                .bold
                                .make())
                      ],
                    ),
                  ),
                ).pSymmetric(v: 20, h: 20),
              ));
            },
          );
        });
  }

  _uppperCardWidgets() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 5, //5 means 50%
              child: Card(
                child: Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        FontAwesomeIcons.temperatureHigh,
                        size: 50,
                      ),
                      Column(
                        children: [
                          "Temperature".text.xl.bold.make(),
                          "$temp O".text.xl.bold.make(),
                        ],
                      )
                    ],
                  ),
                ).pSymmetric(h: 5, v: 5),
              ),
            ),
            Expanded(
              flex: 5, //5 means 50%
              child: Card(
                child: Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        FontAwesomeIcons.water,
                        size: 50,
                      ),
                      Column(
                        children: [
                          "Humidity".text.xl.bold.make(),
                          "$humPer %".text.xl.bold.make(),
                        ],
                      ),
                    ],
                  ),
                ).pSymmetric(h: 5, v: 5),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1, //1 means 100%
              child: Card(
                child: Container(
                  // width: double.infinity,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        CupertinoIcons.bolt,
                        size: 50,
                      ),
                      Column(
                        children: [
                          "Power Usage".text.xl.bold.make(),
                          "$powerUsage kW".text.xl.bold.make(),
                        ],
                      )
                    ],
                  ),
                ).pSymmetric(h: 5, v: 5),
              ),
            ),
          ],
        )
      ],
    );
  }

  _upperIconsWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Vx.blue600, width: 3),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
          child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: Vx.blue600,
                        width: 3.0,
                      ),
                      right: BorderSide(
                        color: Vx.blue600,
                        width: 3.0,
                      ),
                    )),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/icons/humidity.png",
                          color: Vx.blue600,
                          height: 100,
                        ),
                        Column(
                          children: [
                            "Humidity".text.xl.bold.make(),
                            "$humPer %".text.xl.bold.make(),
                          ],
                        )
                      ],
                    ),
                  )),
              Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/power.png",
                        height: 100,
                      ),
                      "Power Usage".text.xl.bold.make(),
                      "$powerUsage kW".text.xl.bold.make(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/temprature.png",
                        height: 100,
                      ),
                      "Temperature".text.xl.bold.make(),
                      "$temp O".text.xl.bold.make(),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: Vx.blue600,
                      width: 3.0,
                    ),
                    top: BorderSide(
                      color: Vx.blue600,
                      width: 3.0,
                    ),
                  )),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/humidity.png",
                        height: 100,
                      ),
                      "Device connected".text.xl.bold.make(),
                      "4".text.xl.bold.make(),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ))
      // .pOnly(left: 10, right: 10, top: 0, bottom: 10)
      ,
    );
  }
}

class RoomSliderWidget extends StatefulWidget {
  BoxConstraints constraints;
  RoomSliderWidget({
    Key? key,
    required this.constraints,
  }) : super(key: key);

  @override
  State<RoomSliderWidget> createState() => _RoomSliderWidgetState();
}

class _RoomSliderWidgetState extends State<RoomSliderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _currentSliderIndex = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [roomModel.OnEntryAdded]);

    return Container(
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            CarouselSlider.builder(
                itemCount: roomModel.RoomListData.roomData!.length,
                itemBuilder: (BuildContext context, _, __) {
                  return roomModel.RoomListData.roomData!.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                          // height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SwitchesPage(
                                          roomIndex: _currentSliderIndex)));
                            },
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              // color: Colors.blueAccent,
                              child: RoomSliderContainerWidget(
                                roomName: roomModel.RoomListData
                                    .roomData![_currentSliderIndex].roomName,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          child: "No room Created".text.make(),
                        );
                },
                options: CarouselOptions(
                    // aspectRatio: 16 / 10,
                    height: widget.constraints.maxHeight - 90,
                    enableInfiniteScroll: true,
                    pauseAutoPlayOnTouch: true,
                    // aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(
                        () {
                          _currentSliderIndex = index;
                        },
                      );
                    })),
            // CarouselSlider(
            //   options: CarouselOptions(
            //     enableInfiniteScroll: true,
            //     // height: 170.0, //make it acc to device size
            //     // autoPlay: true,
            //     // autoPlayInterval: Duration(seconds: 3),
            //     // autoPlayAnimationDuration: Duration(milliseconds: 800),
            //     // autoPlayCurve: Curves.fastOutSlowIn,
            //     pauseAutoPlayOnTouch: true,
            //     // aspectRatio: 2.0,
            //     onPageChanged: (index, reason) {
            //       setState(() {
            //         _currentSliderIndex = index;
            //       });
            //     },
            //   ),
            //   items: cardList.map((card) {
            //     return Builder(builder: (BuildContext context) {
            //       return Container(
            //         padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            //         // height: MediaQuery.of(context).size.height * 0.30,
            //         width: MediaQuery.of(context).size.width,
            //         child: GestureDetector(
            //           onTap: () {
            //             print("item clicked");
            //           },
            //           child: Card(
            //             clipBehavior: Clip.antiAlias,
            //             shape: RoundedRectangleBorder(
            //                 borderRadius:
            //                     BorderRadius.all(Radius.circular(20))),
            //             // color: Colors.blueAccent,
            //             child: card,
            //           ),
            //         ),
            //       );
            //     });
            //   }).toList(),
            // ),

            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                    roomModel.RoomListData.roomData!.length,
                    (index) => Container(
                          width: 10.0,
                          height: 10.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentSliderIndex == index
                                ? Colors.blueAccent
                                : Colors.grey,
                          ),
                        ))

                //   map<Widget>(cardList, (index, url) {
                // return Container(
                //   width: 10.0,
                //   height: 10.0,
                //   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: _currentSliderIndex == index
                //         ? Colors.blueAccent
                //         : Colors.grey,
                //   ),
                // );
                // }),
                ),
          ]),
    );
  }
}

class RoomSliderContainerWidget extends StatelessWidget {
  String roomName;
  RoomSliderContainerWidget({
    Key? key,
    this.roomName = "No Room added",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Vx.blue400,
              Colors.white,
            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("$roomName",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold)),
          Text("More Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
