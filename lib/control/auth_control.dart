library firebase_auth_utility;

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_utility/local_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AuthControl {
  /// Initialize the firebase project.
  /// Provide the Firebase_Option
  initializeApp({required options}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: options,
    );
  }

  /// Phone authentication by phone number
  phoneAuthLogin(
      {required String countryCode,
      required String mobileNumber,
      required Duration? timeout,
      required Function(FirebaseAuthException e) verificationFailed,
      required Function(Map responseData) codeSent}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    int? resendToken;
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: "+$countryCode${mobileNumber.toString()}",
        timeout: timeout ?? const Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) => verificationFailed(e),
        codeSent: (String verificationId, int? resendToken) {
          Map responseData = {};
          responseData['verificationId'] = verificationId;
          responseData['resendToken'] = resendToken;
          resendToken = resendToken;
          codeSent(responseData);
        },
        forceResendingToken: resendToken,
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on Exception catch (e) {
      return e.toString();
    }
  }

  /// Verify firebase auth otp
  Future<dynamic> verifyFirebaseAuthOtp({required requestData}) {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: requestData['verificationId'],
        smsCode: requestData['otp']);

    return signInWithPhone(credential, requestData);
  }

  /// Sign In with phone
  Future<dynamic> signInWithPhone(
      PhoneAuthCredential credential, requestData) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        return userCredential;
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }

  /// Firebase Logout if logged in
  signOutFromFirebase() async {
    await FirebaseAuth.instance.signOut();
  }


  /// Push Notification
  registerNotification() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, provisional: false, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      LocalNotificationService().init((String? payload) {});

      FirebaseMessaging.instance.getToken().then((token) {});

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;

        String? payload = json.encode(message.data);
        LocalNotificationService().showNotification(notification.hashCode,
            notification!.title, notification.body, payload);
      });
    } else {
      // print('User declined or has not accepted permission');
    }

    // Background notification handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}