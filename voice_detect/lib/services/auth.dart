import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_detect/core/DatabaseService.dart';
import 'package:voice_detect/screens/verifyOtp.dart';
import 'package:voice_detect/constants/urlConstants.dart';

class Auth with ChangeNotifier {
  String _userId;
  bool isAuthenticated = false;
  String smsCode;
  int resendToken;
  String verificationId;
  String userType;

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isAuth {
    return isAuthenticated;
  }

  String get usertype {
    return userType;
  }

  String get verifyId {
    return verificationId;
  }

  String get userId {
    return _userId;
  }

  Future<User> getUser() async {
    return _auth.currentUser;
  }

  Future<bool> tryAutoLogin(BuildContext context) async {
    User user = await getUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (user != null) {
      try {
        Provider.of<Auth>(context, listen: false).userType =
            prefs.getString('userType');
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }

  Future<void> logout() async {
    await _auth.signOut();
    isAuthenticated = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  String getCurrentUID() {
    final User user = _auth.currentUser;
    final String uid = user.uid;
    return uid;
  }

  _verificationComplete(AuthCredential credential, BuildContext context) async {
    try {
      await _auth
          .signInWithCredential(credential)
          .then((UserCredential result) async {
        await DatabaseService().addData(
            userType == 'CLIENT'
                ? '$clientUsers/${result.user.uid}'
                : '$masterUsers/${result.user.uid}',
            {
              'phone': result.user.phoneNumber,
              'userType': usertype,
            });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userType', userType);
        Provider.of<Auth>(context, listen: false).isAuthenticated = true;
      });
    } on FirebaseAuthException catch (e) {
      throw e;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future logInPhone(
    String mobile,
    BuildContext context,
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        forceResendingToken: resendToken,
        phoneNumber: mobile,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) async {
          await _verificationComplete(authCredential, context);
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: 'Verification Failed');
        },
        codeSent: (String verifyId, [int forceResendingToken]) {
          resendToken = forceResendingToken;
          Provider.of<Auth>(context, listen: false).verificationId = verifyId;
          notifyListeners();

          Navigator.of(context).pushReplacementNamed(VerifyOTP.routeName);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          Fluttertoast.showToast(msg: 'Timeout');
          print(verificationId);
          print("Timeout");
        },
      );
    } catch (e) {
      print(e);
    }
    return true;
  }

  verifyWithOtp({String otp, BuildContext context}) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      await _verificationComplete(credential, context);
    } on FirebaseAuthException catch (e) {
      throw e;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }
}
