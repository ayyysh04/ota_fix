import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ota_fix/Utils/Loginpage/snackbar.dart';
import 'package:ota_fix/core/store.dart';
import 'package:velocity_x/velocity_x.dart';

class FirebaseAuthData {
  static late FirebaseAuth auth;
  static Future<void> logOut() async {
    await auth.signOut();
    UserData.user = null;
  }

  static Future<bool> signInWithEmailAndPassword(
      String email, String pass, BuildContext context) async {
    try {
      UserData.user = (await auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      ))
          .user;
      if (UserData.user!.emailVerified) {
        CustomSnackBar(context, Text('${UserData.user!.email} signed in'));
      } else {
        CustomSnackBar(context,
            Text('${UserData.user!.email} not verified.Verify to login'));

        return false;
      }

      return true;
    } on FirebaseAuthException catch (e) {
      UserData.user = null;
      switch (e.code) {
        case 'invalid-email':
          CustomSnackBar(context, Text("Email address is invalid"),
              backgroundColor: Vx.red500);
          break;
        case "user-disabled":
          CustomSnackBar(
              context, Text("$email is disibled.Contact administrator"),
              backgroundColor: Vx.red500);
          break;
        case "user-not-found":
          CustomSnackBar(context, Text("User not found"),
              backgroundColor: Vx.red500);
          break;
        case 'wrong-password':
          CustomSnackBar(context, Text("Incorrect Password"),
              backgroundColor: Vx.red500);
          break;
        case "too-many-requests":
          CustomSnackBar(
              context, Text("Too many requests.Please try again later"),
              backgroundColor: Vx.red500);
          break;
        default:
          CustomSnackBar(context, Text("Server Error"),
              backgroundColor: Vx.red500);
      }
    }
    return false;
  }

  static Future<void> resetWithEmailAndPassword(
      String email, BuildContext context) async {
    try {
      await auth.sendPasswordResetEmail(
        email: email,
      );

      CustomSnackBar(context, Text('Reset link sent to $email'));
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'invalid-email':
          CustomSnackBar(context, Text("Email address is invalid"),
              backgroundColor: Vx.red500);
          break;

        case "user-not-found":
          CustomSnackBar(context, Text("User not found"),
              backgroundColor: Vx.red500);
          break;
        case "too-many-requests":
          CustomSnackBar(
              context, Text("Too many requests.Please try again later"),
              backgroundColor: Vx.red500);
          break;
        default:
          CustomSnackBar(context, Text("Server Error"),
              backgroundColor: Vx.red500);
      }
    }
  }

  static Future<bool> createAccount(
      {required String emailId,
      required String pass,
      required BuildContext context}) async {
    try {
      UserCredential userCreds = await auth.createUserWithEmailAndPassword(
        email: emailId,
        password: pass,
      );
      UserData.user = userCreds.user;
      CustomSnackBar(context, Text('$emailId account created'));

      (VxState.store as Mystore)
          .firebaseData
          .updateData(path: UserData.user!.uid, data: "new user");
      return true;
    } on FirebaseAuthException catch (e) {
      UserData.user = null;
      switch (e.code) {
        case 'invalid-email':
          CustomSnackBar(context, Text("Email address is invalid"),
              backgroundColor: Vx.red500);
          break;
        case 'email-already-in-use':
          CustomSnackBar(context, Text("Email address is already in use"),
              backgroundColor: Vx.red500);
          break;
        case 'weak-password':
          CustomSnackBar(
              context, Text("Password too weak,Choose a strong password"),
              backgroundColor: Vx.red500);
          break;

        case "too-many-requests":
          CustomSnackBar(
              context, Text("Too many requests.Please try again later"),
              backgroundColor: Vx.red500);
          break;
        default:
          CustomSnackBar(context, Text("Server Error"),
              backgroundColor: Vx.red500);
      }
    }
    return false;
  }
}

class UserData {
  static User? user;
  static String? displayName;
  static String? displayPhotoLink;
}
