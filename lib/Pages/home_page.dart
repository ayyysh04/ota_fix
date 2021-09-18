import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ota_fix/core/store.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  double temp = 23.5;

  int humPer = 79;

  double powerUsage = 45.4;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // int? _selectedIndex = (VxState.store as Mystore).selectedIndex;
    // VxState.watch(context, on: [OnItemTapped]);
    return Scaffold(
      body: Container(
        child: Flex(
          direction: Axis.vertical,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "OTA Fix"
                      .text
                      .xl5
                      .color(Vx.black)
                      .fontFamily(GoogleFonts.lato().fontFamily!)
                      .bold
                      .make(),
                  _uppperCardWidgets(),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  "Rooms".text.xl2.bold.make(),
                  5.heightBox,
                  RoomSliderWidget(),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              height: 0,
            )
          ],
        ),
      ).pOnly(top: 20, left: 15, right: 15, bottom: 0),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.home, size: 30),
              icon: Icon(Icons.home_outlined, size: 30),
              label: "Home",
              backgroundColor: Colors.transparent),
          BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.bolt_fill, size: 30),
              icon: Icon(CupertinoIcons.bolt, size: 30),
              label: "Power Usage",
              backgroundColor: Colors.transparent),
          BottomNavigationBarItem(
            activeIcon: Icon(FontAwesomeIcons.userAlt, size: 30),
            icon: Icon(
              FontAwesomeIcons.user,
              size: 30,
            ),
            label: "User profile",
          ),
        ],
      ),
    );
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
}

class RoomSliderWidget extends StatefulWidget {
  @override
  State<RoomSliderWidget> createState() => _RoomSliderWidgetState();
}

class _RoomSliderWidgetState extends State<RoomSliderWidget> {
  int _currentSliderIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        // height: 200.0,

        autoPlay: false,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        pauseAutoPlayOnTouch: true,
        // aspectRatio: 2 / 1.2,
        onPageChanged: (index, reason) {
          setState(() {
            _currentSliderIndex = index;
          });
        },
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          width: MediaQuery.of(context).size.width,
          child: Card(
            clipBehavior: Clip.antiAlias,
            // margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            color: Vx.amber100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.2,
                      1
                    ],
                    colors: [
                      Vx.blue400,
                      Vx.white,
                    ]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Data",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold)),
                  Text("Data",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: 2,
    );
  }
}
