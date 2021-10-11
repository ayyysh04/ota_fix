import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:velocity_x/velocity_x.dart';

class FirebaseDatabaseData {
  late DatabaseReference databaseRef;

  intitilizeDatabase() async {
    FirebaseDatabase base = FirebaseDatabase();

    databaseRef = base.reference();
    base.setPersistenceEnabled(true);
    // databaseRef.child()set(value)
    // base.setPersistenceCacheSizeBytes();

    // databaseRef!.keepSynced(true);
  }

//data can be string ,int ,bool,float ,map/json
  Future<void> addData({String path = "", required dynamic data}) async {
    await databaseRef.child(path).set(data);
  }

  Future<void> updateData({String path = "", required dynamic data}) async {
    await databaseRef.child(path).set(data);
  }

  Future<void> deletePathData({String path = ""}) async {
    await databaseRef.child(path).remove();
  }

  dynamic getData({String path = ""}) async {
    DataSnapshot dataSnap = await databaseRef.child(path).get();
    return dataSnap.value;
  }
}
