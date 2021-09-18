import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "OTA Fix".text.xl5.color(Vx.black).bold.make(),
                _uppperCardWidgets(),
              ],
            ),
            Column(
              children: [
                "Rooms".text.xl2.bold.make(),
                5.heightBox,
                _roomGridBuilder(context),
                Divider(
                  thickness: 2,
                  height: 0,
                )
              ],
            ),
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

  Container _roomGridBuilder(BuildContext context) {
    return Container(
      height: 160,
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? 3
                  : 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: (3 / 1),
        ),
        itemBuilder: (
          context,
          index,
        ) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ElevatedButton(
                onPressed: () {},
                child: "Room ${index + 1}".text.xl.bold.make()),
          );
        },
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
