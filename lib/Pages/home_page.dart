import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ota_fix/Pages/power_usage_page.dart';
import 'package:ota_fix/Pages/profile_page.dart';
import 'package:ota_fix/Pages/switches_page.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController pageController;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
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
    // int? _selectedIndex = (VxState.store as Mystore).selectedIndex;
    // VxState.watch(context, on: [OnItemTapped]);
    return Scaffold(
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
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

  Widget _homepage() {
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
                  "Rooms".text.xl2.bold.make(),
                  5.heightBox,
                  RoomSliderWidget(
                    constraints: constraints,
                  ),
                ],
              );
            }),
          ),
          Divider(
            thickness: 2,
            height: 0,
          )
        ],
      ),
    ).pOnly(top: 20, left: 15, right: 15, bottom: 0);
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

  int items = 3;
  int _currentSliderIndex = 0;
  List cardList = [Item1(), Item1()];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            CarouselSlider.builder(
                itemCount: items,
                itemBuilder: (BuildContext context, _, __) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                    // height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SwitchesPage(roomName: "My Room")));
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // color: Colors.blueAccent,
                        child: Item1(),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                    // aspectRatio: 16 / 10,
                    height: widget.constraints.maxHeight - 70,
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
                    items,
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

class Item1 extends StatelessWidget {
  const Item1({
    Key? key,
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
    );
  }
}
