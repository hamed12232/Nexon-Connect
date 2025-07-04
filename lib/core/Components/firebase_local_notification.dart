import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/core/Components/local_notification.dart';

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
    handleForeground();
  }

  Future<void> handleMessages(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? "null");
  }

  void handleForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification().showBasicNotification(message);
    });
  }

  Future<void> sendPushNotification({
  required String deviceToken,
  required String accessToken,
   required String follower
}) async {
  final url = Uri.parse("https://fcm.googleapis.com/v1/projects/demosocialapp-ef38c/messages:send");

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final body = jsonEncode({
    "message": {
      "token": deviceToken,
      "notification": {
        "title": "New Follower!",
        "body": "$follower started following you",
      }
    }
  });

  final response = await http.post(url, headers: headers, body: body);

  log('Status: ${response.statusCode}');
  log('Body: ${response.body}');
}
}