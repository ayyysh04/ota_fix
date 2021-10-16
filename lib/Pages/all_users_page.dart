import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ota_fix/core/store.dart';
import 'package:ota_fix/model/all_users_model.dart';
import 'package:ota_fix/model/firebase_auth_utility.dart';
import 'package:ota_fix/model/firebase_database_utility.dart';
import 'package:ota_fix/model/firestore_utility.dart';
import 'package:velocity_x/velocity_x.dart';

class AllUsersPage extends StatefulWidget {
  AllUsersPage({Key? key}) : super(key: key);

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  late StreamSubscription<Event> userIdDataAddSubscription;
  late StreamSubscription<Event> userIdDataChangeSubscription;

  @override
  void initState() {
    super.initState();

    AllUserIDData.allUserIdData = [];
    _getParentData();
    Query _userdIdQuery = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuthData.auth.currentUser!.uid)
        .child("child account")
        .orderByKey();
    userIdDataAddSubscription = _userdIdQuery.onChildAdded.listen((event) {
      OnEntryAdded(event: event);
    });

    userIdDataChangeSubscription = _userdIdQuery.onChildChanged.listen((event) {
      OnEntryChanged(event: event);
    });
    //more stream callback are there
  }

  @override
  void dispose() {
    userIdDataAddSubscription.cancel();
    userIdDataChangeSubscription.cancel();

    super.dispose();
  }

  _getParentData() async {
    firestore.QuerySnapshot _userDataQuery2 = await firestore
        .FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuthData.auth.currentUser!.uid)
        .collection("parent account")
        .get();
    AllUserIDData.allUserIdData!.add(UserIdModel(
        isAdmin: true,
        isActive: true,
        uidKey: FirebaseAuthData.auth.currentUser!.uid,
        userModel: _userDataQuery2.docs.isEmpty
            ? null
            : UserDataModel.fromQueryDocumentSnapshot(
                _userDataQuery2.docs.first)));
  }

  _getAllUsersData() async {
    // firestore.QuerySnapshot _userDataQuery = await firestore
    //     .FirebaseFirestore.instance
    //     .collection("users")
    //     .where(firestore.FieldPath.documentId,
    //         where: )
    // .get();
    // firestore.QuerySnapshot allUserDataMap = _userDataQuery;

    // AllUsersData.fromMap(allUserDataMap);
  }

  _addNewUser(String userName) {
    if (userName.length > 0) {
      UserIdModel newUser = new UserIdModel(
          uidKey: userName.toString(), isActive: false, isAdmin: false);

      FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(FirebaseAuthData.auth.currentUser!.uid)
          .child("child account")
          .set(newUser.toMap());
    }
  }

  _updateUser(UserIdModel data) //this will also callback the streams
  {
    FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuthData.auth.currentUser!.uid)
        .child("child account")
        .update(data.toMap());
  }

  _deleteUser(String uid, int index) {
    FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuthData.auth.currentUser!.uid)
        .child("child account")
        .child(uid)
        .remove()
        .then((_) {
      setState(() {
        AllUserIDData.allUserIdData!.removeAt(index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // AllUserIDData.allUserIdData!.forEach((element) {
    //   print(element.isActive);
    //   print(element.uidKey);
    //   print(element.userModel?.isAdmin);
    // });
    VxState.watch(context, on: [OnEntryAdded, OnEntryChanged]);
    return Scaffold(
      appBar: AppBar(
        title: "All Users".text.color(Vx.black).make(),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: AllUserIDData.allUserIdData!.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator().centered(),
                  10.heightBox,
                  "Loading".text.lg.make()
                ],
              )
            : Column(
                children: [
                  10.heightBox,
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Vx.green400),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Vx.green200,
                    ),
                    child:
                        " Total ${AllUserIDData.allUserIdData!.length} active Users"
                            .text
                            .lg
                            .color(Vx.green600)
                            .make()
                            .centered(),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: ListView.separated(
                      itemCount: AllUserIDData.allUserIdData!.length,
                      itemBuilder: (BuildContext context, int index) {
                        UserDataModel? _userData =
                            AllUserIDData.allUserIdData![index].userModel;
                        return Container //we can use dissmisble here
                            (
                          // color: Vx.amber100,
                          // height: 120,
                          child: Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      color: Vx.gray200),
                                  clipBehavior: Clip.antiAlias,
                                  child: Icon(
                                    LineAwesomeIcons.user,
                                    size: 100,
                                  )),
                              15.widthBox,
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (_userData == null
                                          ? "not set"
                                          : _userData.name)
                                      .toString()
                                      .text
                                      .lg
                                      .bold
                                      .make(),
                                  10.heightBox,
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Visibility(
                                        visible: AllUserIDData
                                            .allUserIdData![index].isActive,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Vx.green400),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Vx.green200,
                                          ),
                                          child: "Active User"
                                              .text
                                              .color(Vx.green600)
                                              .make()
                                              .pSymmetric(h: 10, v: 5),
                                        ),
                                      ),
                                      10.widthBox,
                                      Visibility(
                                        visible: AllUserIDData
                                            .allUserIdData![index].isAdmin,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Vx.red400),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Vx.red200,
                                          ),
                                          child: "Admin"
                                              .text
                                              .color(Vx.red500)
                                              .make()
                                              .pSymmetric(h: 10, v: 5),
                                        ),
                                      ),
                                    ],
                                  ),
                                  10.heightBox,
                                  MaterialButton(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 10),
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.delete_outline_rounded,
                                          color: Vx.red500,
                                        ),
                                        "Remove User"
                                            .text
                                            .color(Vx.red500)
                                            .make()
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return 20.heightBox;
                      },
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    minWidth: double.infinity,
                    color: Vx.black,
                    height: 60,
                    onPressed: () {},
                    child: "ADD USER".text.xl.color(Vx.white).make(),
                  ),
                  Spacer(
                    flex: 1,
                  )
                ],
              ),
      ),
    );
  }
}
