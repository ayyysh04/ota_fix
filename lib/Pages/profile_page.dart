import 'dart:io';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ota_fix/Utils/routes.dart';
import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/firebase_auth_utility.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfilePage extends StatelessWidget {
  String? _displayName;
  ProfilePage({Key? key}) : super(key: key);
  File? image;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white10,
      child: Column(
        children: <Widget>[
          SizedBox(height: 40),
          _profileHeader(),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Change Username'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Do you want to change the username ?'),
                                  10.heightBox,
                                  TextFormField(
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        hintText: "Enter Username Here",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        contentPadding: EdgeInsets.all(0)),
                                    keyboardType: TextInputType.name,
                                    onChanged: (value) {
                                      _displayName = value;
                                    },
                                  )
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 13)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_displayName != null) {}
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 13)),
                                  child: Text('Yes'),
                                ),
                              ],
                            ));
                  },
                  child: _profileListItems(
                      context: context,
                      icon: LineAwesomeIcons.user_shield,
                      title: 'Change Username',
                      disible: false),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutes.allUsersRoute);
                  },
                  child: _profileListItems(
                      context: context,
                      icon: LineAwesomeIcons.user_shield,
                      title: 'All Users',
                      disible: false),
                ),
                _profileListItems(
                    context: context,
                    icon: LineAwesomeIcons.question_circle,
                    title: 'Help & Support',
                    disible: true),
                _profileListItems(
                    context: context,
                    icon: LineAwesomeIcons.cog,
                    title: 'Settings',
                    disible: true),
                _profileListItems(
                    context: context,
                    icon: LineAwesomeIcons.user_shield,
                    title: 'Privacy',
                    disible: true),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuthData.logOut();
                    Navigator.pushNamed(context, MyRoutes.loginRoute);
                  },
                  child: _profileListItems(
                      context: context,
                      icon: LineAwesomeIcons.alternate_sign_out,
                      title: 'Logout',
                      disible: false),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _profileHeader() {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          margin: EdgeInsets.only(top: 30),
          child: Stack(
            children: <Widget>[
              image == null
                  ? Container(
                      clipBehavior: Clip.antiAlias,
                      child: Icon(
                        LineAwesomeIcons.user_plus,
                        size: 50,
                      ).centered(),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(),
                        color: Color(0xFFF3F7FB),
                      ),
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(image!),
                    ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Vx.black,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    // heightFactor: 10 * 1.5,
                    // widthFactor: 10 * 1.5,
                    child: GestureDetector(
                      onTap: () async {},
                      child: Icon(
                        LineAwesomeIcons.pen,
                        color: Vx.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Default User",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "ayushiit2003@gmail.com",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Container _profileListItems(
      {required BuildContext context,
      required String title,
      required IconData icon,
      required bool disible}) {
    return Container(
      height: 65,
      margin: EdgeInsets.fromLTRB(40, 0, 40, 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xFFF3F7FB),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 25,
          ),
          SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              color: Vx.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          if (disible == false)
            Icon(
              LineAwesomeIcons.angle_right,
              size: 25,
            ),
        ],
      ),
    );
  }
}
