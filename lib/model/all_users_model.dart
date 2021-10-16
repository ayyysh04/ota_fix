import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';
import 'package:ota_fix/model/firebase_auth_utility.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:ota_fix/core/store.dart';

// -x-x-x-x-x-x-x-x-x-x-x-x-x-From cloud firestore-x-x-x-x-x-x-x-x-x-x-x
class UserDataModel {
  String? name;
  String? photoLocationCloud;

  String? photoLocationLocal;
  UserDataModel({
    this.name,
    this.photoLocationCloud,
    this.photoLocationLocal,
  });

  // AllUsersModel copyWith(
  //     {String? name,
  //     String? photoLocationCloud,
  //     required bool isActive,
  //     required bool isAdmin,
  //     String? photoLocationLocal,
  //     required String uid}) {
  //   return AllUsersModel(
  //     name: name ?? this.name,
  //     photoLocationCloud: photoLocationCloud ?? this.photoLocationCloud,
  //     isActive: isActive  ??this.isActive,
  //     isAdmin: isAdmin ?? this.isAdmin,
  //     photoLocationLocal: photoLocationLocal ?? this.photoLocationLocal,
  //     uid: this.uid,
  //   );
  // }

  factory UserDataModel.fromQueryDocumentSnapshot(
      firestore.QueryDocumentSnapshot map) {
    return UserDataModel(
      name: map["name"],
      photoLocationCloud: map['photoLocationCloud'],
      photoLocationLocal: map['photoLocationLocal'],
    );
  }

  // factory AllUsersModel.fromMapUID(Map map) {
  //   return AllUsersModel(
  //     uid: map[],
  //     isActive: map['']
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoLocationCloud': photoLocationCloud,
      'photoLocationLocal': photoLocationLocal,
    };
  }

  String toJson() => json.encode(toMap());
}

//-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-From rtdb -x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-
class UserIdModel {
  String? uidKey;
  bool isActive;
  bool isAdmin;
  UserDataModel? userModel;
  UserIdModel(
      {required this.uidKey,
      required this.isActive,
      this.userModel,
      this.isAdmin = false});

  Map<String, dynamic> toMap() {
    return {"$uidKey": isActive};
  }

  factory UserIdModel.fromsnapshot(DataSnapshot data,
      {UserDataModel? fullData}) {
    return UserIdModel(
        uidKey: data.key, isActive: data.value, userModel: fullData);
  }
}

class AllUserIDData {
  static List<UserIdModel>? allUserIdData;

  static UserIdModel getByUId(String uidKey) => allUserIdData!
      .firstWhere((element) => element.uidKey == uidKey, orElse: null);
}

class OnEntryAdded extends VxMutation<Mystore> {
  Event event;
  OnEntryAdded({
    required this.event,
  });
  @override
  perform() async {
    print("Entry added");
    firestore.QuerySnapshot _userDataQuery = await firestore
        .FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuthData.auth.currentUser!.uid)
        .collection("child account")
        .where(firestore.FieldPath.documentId, isEqualTo: event.snapshot.key)
        .get();

    AllUserIDData.allUserIdData!.add(UserIdModel.fromsnapshot(event.snapshot,
        fullData: _userDataQuery.docs.isEmpty
            ? null
            : UserDataModel.fromQueryDocumentSnapshot(
                _userDataQuery.docs.first)));
  }
}

class OnEntryChanged extends VxMutation<Mystore> {
  Event event;
  OnEntryChanged({
    required this.event,
  });
  @override
  perform() {
    print("Entry changed");
    UserIdModel oldEntry = AllUserIDData.allUserIdData!.firstWhere((entry) {
      return entry.uidKey == event.snapshot.key;
    });

    AllUserIDData.allUserIdData![AllUserIDData.allUserIdData!.indexOf(oldEntry)]
        .isActive = event.snapshot.value;
    // AllUserIDData
    //         .allUserIdData![AllUserIDData.allUserIdData!.indexOf(oldEntry)] =
    //     UserIdModel.fromsnapshot(event.snapshot);
  }
}
