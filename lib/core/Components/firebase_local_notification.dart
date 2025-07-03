import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:myapp/features/discover/ui/discover_screen.dart';

class FirebaseLocalNotification {
  static final FirebaseLocalNotification _instance =
      FirebaseLocalNotification._internal();

  factory FirebaseLocalNotification() => _instance;

  FirebaseLocalNotification._internal();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    log("Token: $token");
    FirebaseMessaging.onBackgroundMessage(handleMessages);
  }

  Future<void> handleMessages(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? "null");
  }
}
