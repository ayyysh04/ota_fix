import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUtility {
  static late final FirebaseFirestore _firestoreInstance;
  static void intitilizeFirestore() async {
    _firestoreInstance = FirebaseFirestore.instance;
  }

  static Future<void> addData(
      {required dynamic data,
      required String collectionPath,
      required String docPath}) async {
    DocumentReference documentReferencer =
        _firestoreInstance.collection(collectionPath).doc(docPath);

    await documentReferencer.set(data).catchError((e) {
      print(e);
    });
  }

  static Future<void> updateData(
      {required dynamic data,
      required String collectionPath,
      required String docPath}) async {
    DocumentReference documentReferencer =
        _firestoreInstance.collection(collectionPath).doc(docPath);
    try {
      await documentReferencer.update(data);
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  static Future<DocumentSnapshot> readData(
      {required String collectionPath, required String docPath}) {
    DocumentReference documentReferencer =
        _firestoreInstance.collection(collectionPath).doc(docPath);

    return documentReferencer.get();
  }

  static Stream<DocumentSnapshot> streamData(
      {required String collectionPath, required String docPath}) {
    DocumentReference documentReferencer =
        _firestoreInstance.collection(collectionPath).doc(docPath);

    return documentReferencer.snapshots();
  }

  static Future<void> deleteItem(
      {required String collectionPath, required String docPath}) async {
    DocumentReference documentReferencer =
        _firestoreInstance.collection(collectionPath).doc(docPath);

    try {
      await documentReferencer.delete();
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }
}
