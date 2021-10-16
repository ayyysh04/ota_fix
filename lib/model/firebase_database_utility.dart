import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

class FirebaseDatabaseUtility {
  static late DatabaseReference _databaseRef;

  static void intitilizeDatabase() async {
    FirebaseDatabase base = FirebaseDatabase.instance;

    _databaseRef = base.reference();
    base.setPersistenceEnabled(true);
    // databaseRef.child()set(value)
    // base.setPersistenceCacheSizeBytes();

    // databaseRef!.keepSynced(true);
  }

//data can be string ,int ,bool,float ,map/json
  static Future<void> addData({String path = "", required dynamic data}) async {
    await _databaseRef.child(path).set(data);
  }

  static Future<void> updateData(
      {String path = "", required Map<String, dynamic> data}) async {
    await _databaseRef.child(path).update(data).catchError((error, stackTrace) {
      print(error);
    });
  }

  static Future<void> deletePathData({String path = ""}) async {
    await _databaseRef.child(path).remove();
  }

  static dynamic getDataAsMap(
      {String path = ""}) async //return null if given path not found
  {
    DataSnapshot dataSnap =
        await _databaseRef.child(path).get().catchError((e) {
      print(e);
    });
    return dataSnap.value;
  }
}
